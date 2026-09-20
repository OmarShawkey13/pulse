import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';
import 'package:pulse/features/home/presentation/widgets/mini_player/mini_player_control_button.dart';

class MiniPlayerControls extends StatelessWidget {
  const MiniPlayerControls({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = HomeCubit.get(context);
    return StreamBuilder<PlaybackState>(
      stream: cubit.playbackStateStream,
      builder: (context, snapshot) {
        final playing = snapshot.data?.playing ?? false;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            MiniPlayerControlButton(
              icon: Icons.skip_previous_rounded,
              onPressed: cubit.playPrevious,
            ),
            MiniPlayerControlButton(
              icon: playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 32,
              onPressed: () => playing
                  ? cubit.pauseSong()
                  : cubit.currentSongPath == null
                  ? null
                  : cubit.playSong(cubit.currentSongPath!),
            ),
            MiniPlayerControlButton(
              icon: Icons.skip_next_rounded,
              onPressed: cubit.playNext,
            ),
          ],
        );
      },
    );
  }
}
