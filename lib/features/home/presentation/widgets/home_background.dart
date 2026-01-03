import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/utils/cubit/home_cubit.dart';
import 'package:pulse/core/utils/cubit/home_state.dart';

class HomeBackground extends StatelessWidget {
  final Widget child;

  const HomeBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      buildWhen: (_, state) => state is HomeChangeThemeState,
      builder: (context, state) {
        final isDark = homeCubit.isDarkMode;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [
                      ColorsManager.darkGradientStart,
                      ColorsManager.darkGradientEnd,
                    ]
                  : [
                      ColorsManager.lightGradientStart,
                      ColorsManager.lightGradientEnd,
                    ],
            ),
          ),
          child: child,
        );
      },
    );
  }
}
