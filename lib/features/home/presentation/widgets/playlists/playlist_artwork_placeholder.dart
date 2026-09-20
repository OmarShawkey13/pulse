import 'package:flutter/material.dart';
import 'package:pulse/core/theme/colors.dart';

class PlaylistArtworkPlaceholder extends StatelessWidget {
  const PlaylistArtworkPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorsManager.primary,
            ColorsManager.primary.withValues(alpha: 0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Icon(
        Icons.music_note_rounded,
        size: 100,
        color: ColorsManager.white24,
      ),
    );
  }
}
