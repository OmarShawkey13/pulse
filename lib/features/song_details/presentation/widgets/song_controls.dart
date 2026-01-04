import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:pulse/core/utils/constants/spacing.dart';
import 'package:pulse/core/utils/cubit/home_cubit.dart';

class SongControls extends StatelessWidget {
  final String songPath;

  const SongControls({
    super.key,
    required this.songPath,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = homeCubit;
    final primaryColor = Theme.of(context).primaryColor;

    return StreamBuilder<PlaybackState>(
      stream: cubit.playbackStateStream,
      builder: (context, snapshot) {
        final playing = snapshot.data?.playing ?? false;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: cubit.playPrevious,
              icon: const Icon(
                Icons.skip_previous_rounded,
                size: 45,
                color: Colors.white,
              ),
            ),
            horizontalSpace24,
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () =>
                    playing ? cubit.pauseSong() : cubit.playSong(songPath),
                icon: Icon(
                  playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  size: 50,
                  color: primaryColor,
                ),
              ),
            ),
            horizontalSpace24,
            IconButton(
              onPressed: cubit.playNext,
              icon: const Icon(
                Icons.skip_next_rounded,
                size: 45,
                color: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }
}
