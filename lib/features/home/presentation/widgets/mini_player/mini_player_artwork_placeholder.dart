import 'package:flutter/material.dart';
import 'package:pulse/core/theme/colors.dart';

class MiniPlayerArtworkPlaceholder extends StatelessWidget {
  final double size;

  const MiniPlayerArtworkPlaceholder({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: ColorsManager.darkTextSecondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.music_note_rounded,
        color: ColorsManager.lightSurface.withValues(alpha: 0.7),
        size: size * 0.5,
      ),
    );
  }
}
