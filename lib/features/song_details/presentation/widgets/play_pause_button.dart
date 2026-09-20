import 'package:flutter/material.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';

class PlayPauseButton extends StatelessWidget {
  final bool playing;
  final String songPath;
  final Color auraColor;
  final double size;

  const PlayPauseButton({
    super.key,
    required this.playing,
    required this.songPath,
    required this.auraColor,
    this.size = 72,
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
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: auraColor,
          boxShadow: [
            BoxShadow(
              color: auraColor.withValues(alpha: 0.3),
              blurRadius: size * 0.35,
              spreadRadius: size * 0.055,
              offset: Offset(0, size * 0.11),
            ),
            BoxShadow(
              color: ColorsManager.white.withValues(alpha: 0.2),
              blurRadius: size * 0.11,
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
              size: size * 0.58,
              color: ColorsManager.white,
            ),
          ),
        ),
      ),
    );
  }
}
