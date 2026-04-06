import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';

class MiniPlayerControls extends StatelessWidget {
  const MiniPlayerControls({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlaybackState>(
      stream: homeCubit.playbackStateStream,
      builder: (context, snapshot) {
        final playing = snapshot.data?.playing ?? false;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ControlButton(
              icon: Icons.skip_previous_rounded,
              onPressed: homeCubit.playPrevious,
            ),
            _ControlButton(
              icon: playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 32,
              onPressed: () => playing
                  ? homeCubit.pauseSong()
                  : homeCubit.playSong(homeCubit.currentSongPath ?? ""),
            ),
            _ControlButton(
              icon: Icons.skip_next_rounded,
              onPressed: homeCubit.playNext,
            ),
          ],
        );
      },
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;

  const _ControlButton({
    required this.icon,
    required this.onPressed,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: Icon(icon, size: size),
      onPressed: onPressed,
    );
  }
}
