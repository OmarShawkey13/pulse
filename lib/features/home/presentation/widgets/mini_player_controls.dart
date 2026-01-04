import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:pulse/core/utils/cubit/home_cubit.dart';

class MiniPlayerControls extends StatelessWidget {
  final String songPath;

  const MiniPlayerControls({
    super.key,
    required this.songPath,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlaybackState>(
      stream: homeCubit.playbackStateStream,
      builder: (context, snapshot) {
        final playing = snapshot.data?.playing ?? false;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.skip_previous_rounded),
              onPressed: homeCubit.playPrevious,
            ),
            IconButton(
              icon: Icon(
                playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
              ),
              onPressed: () => playing
                  ? homeCubit.pauseSong()
                  : homeCubit.playSong(songPath),
            ),
            IconButton(
              icon: const Icon(Icons.skip_next_rounded),
              onPressed: homeCubit.playNext,
            ),
          ],
        );
      },
    );
  }
}
