import 'package:flutter/material.dart';
import 'package:pulse/core/theme/colors.dart';

class SongPlayingIndicator extends StatelessWidget {
  const SongPlayingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: ColorsManager.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: ColorsManager.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(
        Icons.pause_rounded,
        color: Colors.white,
        size: 20,
      ),
    );
  }
}
