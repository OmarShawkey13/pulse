import 'package:flutter/material.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/utils/constants/spacing.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';

class SongInfo extends StatelessWidget {
  final String title;
  final String artist;
  final bool isPlaying;

  const SongInfo({
    super.key,
    required this.title,
    required this.artist,
    required this.isPlaying,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = themeCubit.isDarkMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStylesManager.medium16.copyWith(
            fontWeight: isPlaying ? FontWeight.bold : FontWeight.w600,
            color: isPlaying
                ? ColorsManager.primary
                : (isDark
                      ? ColorsManager.darkTextPrimary
                      : ColorsManager.lightTextPrimary),
            letterSpacing: -0.2,
          ),
        ),
        verticalSpace4,
        Text(
          artist,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStylesManager.regular12.copyWith(
            color: isPlaying
                ? (isDark
                          ? ColorsManager.darkTextPrimary
                          : ColorsManager.lightTextPrimary)
                      .withValues(alpha: 0.7)
                : (isDark
                      ? ColorsManager.darkTextSecondary
                      : ColorsManager.lightTextSecondary),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
