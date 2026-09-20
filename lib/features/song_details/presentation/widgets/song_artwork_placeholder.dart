import 'package:flutter/material.dart';
import 'package:pulse/core/theme/colors.dart';

class SongArtworkPlaceholder extends StatelessWidget {
  final bool isDark;

  const SongArtworkPlaceholder({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDark ? ColorsManager.darkCard : ColorsManager.lightDivider,
      child: Icon(
        Icons.music_note_rounded,
        size: 80,
        color: ColorsManager.primary.withValues(alpha: 0.4),
      ),
    );
  }
}
