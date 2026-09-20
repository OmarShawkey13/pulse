import 'package:flutter/material.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/features/home/presentation/widgets/song_list/song_playing_indicator.dart';

class SongItemTrailingAction extends StatelessWidget {
  final bool isDark;
  final bool isPlaying;

  const SongItemTrailingAction({
    super.key,
    required this.isDark,
    required this.isPlaying,
  });

  @override
  Widget build(BuildContext context) {
    if (isPlaying) {
      return const SongPlayingIndicator();
    }
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: (isDark ? ColorsManager.white : ColorsManager.black).withValues(
          alpha: 0.03,
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.play_arrow_rounded,
        color:
            (isDark
                    ? ColorsManager.darkTextSecondary
                    : ColorsManager.lightTextSecondary)
                .withValues(alpha: 0.6),
        size: 22,
      ),
    );
  }
}
