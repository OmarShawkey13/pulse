import 'package:flutter/material.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';

class PlayPauseButton extends StatelessWidget {
  final bool playing;
  final String songPath;
  final Color auraColor;

  const PlayPauseButton({
    super.key,
    required this.playing,
    required this.songPath,
    required this.auraColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => playing
          ? HomeCubit.get(context).pauseSong()
          : HomeCubit.get(context).playSong(songPath),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        height: 72,
        width: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: auraColor,
          boxShadow: [
            BoxShadow(
              color: auraColor.withValues(alpha: 0.3),
              blurRadius: 25,
              spreadRadius: 4,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.2),
              blurRadius: 8,
              spreadRadius: -2,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: Icon(
              playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
              key: ValueKey(playing),
              size: 42,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
