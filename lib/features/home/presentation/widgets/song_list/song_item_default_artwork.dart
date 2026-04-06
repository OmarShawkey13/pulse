import 'package:flutter/material.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';

class SongItemDefaultArtwork extends StatelessWidget {
  final bool isPlaying;

  const SongItemDefaultArtwork({
    super.key,
    required this.isPlaying,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = themeCubit.isDarkMode;
    return Container(
      decoration: BoxDecoration(
        color: isPlaying
            ? ColorsManager.primary.withValues(alpha: 0.2)
            : (isDark ? ColorsManager.darkCard : ColorsManager.lightDivider),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        Icons.music_note_rounded,
        size: 28,
        color: isPlaying
            ? ColorsManager.primary
            : (isDark
                  ? ColorsManager.darkTextSecondary
                  : ColorsManager.lightTextSecondary),
      ),
    );
  }
}
