import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/utils/cubit/home_cubit.dart';

class SongSeekBar extends StatelessWidget {
  const SongSeekBar({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = homeCubit;

    return StreamBuilder<MediaItem?>(
      stream: cubit.audioHandler.mediaItem,
      builder: (context, mediaSnapshot) {
        final duration = mediaSnapshot.data?.duration ?? Duration.zero;

        return StreamBuilder<Duration>(
          stream: cubit.positionStream,
          builder: (context, positionSnapshot) {
            var position = positionSnapshot.data ?? Duration.zero;
            if (position > duration) position = duration;

            return Column(
              children: [
                Slider(
                  value: position.inSeconds.toDouble(),
                  max: duration.inSeconds > 0
                      ? duration.inSeconds.toDouble()
                      : 1,
                  onChanged: (v) => cubit.seek(Duration(seconds: v.toInt())),
                  activeColor: Colors.white,
                  inactiveColor: Colors.white24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _DurationText(position),
                    _DurationText(duration),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _DurationText extends StatelessWidget {
  final Duration duration;

  const _DurationText(this.duration);

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final m = twoDigits(duration.inMinutes.remainder(60));
    final s = twoDigits(duration.inSeconds.remainder(60));

    return Text(
      '$m:$s',
      style: TextStylesManager.regular12.copyWith(
        color: Colors.white70,
      ),
    );
  }
}
