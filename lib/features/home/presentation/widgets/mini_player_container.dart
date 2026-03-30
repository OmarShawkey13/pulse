import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';

class MiniPlayerContainer extends StatelessWidget {
  final double value; // From 0.0 (mini) to 1.0 (full)
  final double minHeight;
  final double maxHeight;
  final Widget child;

  const MiniPlayerContainer({
    super.key,
    required this.value,
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final currentHeight = lerpDouble(minHeight, maxHeight, value)!;
    final isDark = themeCubit.isDarkMode;
    return RepaintBoundary(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          height: currentHeight,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: isDark ? ColorsManager.darkCard : ColorsManager.lightSurface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(lerpDouble(20.0, 0.0, value)!),
            ),
            boxShadow: value < 0.1
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ]
                : null,
          ),
          child: child,
        ),
      ),
    );
  }
}
