import 'package:flutter/material.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';

class DurationText extends StatelessWidget {
  final Duration duration;

  const DurationText(this.duration, {super.key});

  @override
  Widget build(BuildContext context) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');

    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final isDark = ThemeCubit.get(context).isDarkMode;

    return Text(
      '$minutes:$seconds',
      style: TextStylesManager.bold12.copyWith(
        color: isDark
            ? ColorsManager.darkTextSecondary
            : ColorsManager.lightTextSecondary,
      ),
    );
  }
}
