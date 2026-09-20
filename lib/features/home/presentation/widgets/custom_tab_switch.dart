import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';
import 'package:pulse/core/utils/cubit/theme/theme_state.dart';
import 'package:pulse/features/home/presentation/widgets/tab_indicator.dart';
import 'package:pulse/features/home/presentation/widgets/tab_item.dart';

class CustomTabSwitch extends StatefulWidget {
  final int selectedIndex;
  final void Function(int) onTap;
  final List<String> tabs;

  const CustomTabSwitch({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    required this.tabs,
  });

  @override
  State<CustomTabSwitch> createState() => _CustomTabSwitchState();
}

class _CustomTabSwitchState extends State<CustomTabSwitch>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      upperBound: widget.tabs.length - 1.0,
    )..value = widget.selectedIndex.toDouble();
  }

  @override
  void didUpdateWidget(CustomTabSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _controller.animateTo(
        widget.selectedIndex.toDouble(),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (_, state) =>
          state is ThemeChangeThemeState || state is ThemeLanguageUpdatedState,
      builder: (context, state) {
        final isDark = ThemeCubit.get(context).isDarkMode;
        final bgColor = isDark
            ? ColorsManager.darkCard.withValues(alpha: 0.45)
            : ColorsManager.lightDivider;
        final unselectedColor = isDark
            ? ColorsManager.darkTextSecondary
            : ColorsManager.lightTextSecondary;
        return Container(
          height: 48,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final tabWidth = constraints.maxWidth / widget.tabs.length;

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onHorizontalDragUpdate: (d) => _controller.value =
                    (_controller.value + d.delta.dx / tabWidth).clamp(
                      0.0,
                      _controller.upperBound,
                    ),
                onHorizontalDragEnd: (_) {
                  final idx = _controller.value.round();
                  _controller.animateTo(
                    idx.toDouble(),
                    curve: Curves.easeOutCubic,
                  );
                  if (idx != widget.selectedIndex) widget.onTap(idx);
                },
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) => Stack(
                    children: [
                      Positioned(
                        left: _controller.value * tabWidth,
                        top: 0,
                        bottom: 0,
                        width: tabWidth,
                        child: const TabIndicator(),
                      ),
                      child!,
                    ],
                  ),
                  child: Row(
                    children: List.generate(
                      widget.tabs.length,
                      (i) => TabItem(
                        title: widget.tabs[i],
                        index: i,
                        controller: _controller,
                        unselectedColor: unselectedColor,
                        onTap: () => widget.onTap(i),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
