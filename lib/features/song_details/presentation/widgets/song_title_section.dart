import 'package:flutter/material.dart';
import 'package:pulse/core/models/song_model.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/utils/constants/primary/marquee_text.dart';
import 'package:pulse/core/utils/constants/spacing.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';

class SongTitleSection extends StatelessWidget {
  final SongModel song;

  const SongTitleSection({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    final isDark = themeCubit.isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MarqueeText(
          text: song.title,
          style: TextStylesManager.bold26.copyWith(
            color: isDark
                ? ColorsManager.darkTextPrimary
                : ColorsManager.lightTextPrimary,
            letterSpacing: -0.5,
          ),
          duration: const Duration(seconds: 12),
        ),
        verticalSpace4,
        Text(
          song.artist,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStylesManager.medium16.copyWith(
            color: isDark
                ? ColorsManager.darkTextSecondary
                : ColorsManager.lightTextSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
