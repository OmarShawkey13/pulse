import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';

class SongSeekBar extends StatefulWidget {
  const SongSeekBar({super.key});

  @override
  State<SongSeekBar> createState() => _SongSeekBarState();
}

class _SongSeekBarState extends State<SongSeekBar> {
  double? _dragValue;

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

            final double currentValue =
                _dragValue ?? position.inSeconds.toDouble();

            return Column(
              children: [
                SliderTheme(
                  data: const SliderThemeData(
                    trackHeight: 4,
                    thumbShape: RoundSliderThumbShape(
                      enabledThumbRadius: 6,
                    ),
                    overlayShape: RoundSliderOverlayShape(
                      overlayRadius: 14,
                    ),
                    activeTrackColor: ColorsManager.primary,
                    inactiveTrackColor: Color(0x265B6CFF), // Primary with 0.15 alpha
                    thumbColor: ColorsManager.primary,
                  ),
                  child: Slider(
                    value: currentValue.clamp(
                      0,
                      duration.inSeconds > 0
                          ? duration.inSeconds.toDouble()
                          : 1.0,
                    ),
                    max: duration.inSeconds > 0
                        ? duration.inSeconds.toDouble()
                        : 1,
                    onChanged: (v) {
                      setState(() {
                        _dragValue = v;
                      });
                    },
                    onChangeEnd: (v) {
                      cubit.seek(Duration(seconds: v.toInt()));
                      setState(() {
                        _dragValue = null;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _DurationText(
                        _dragValue != null
                            ? Duration(seconds: _dragValue!.toInt())
                            : position,
                      ),
                      _DurationText(duration),
                    ],
                  ),
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
    final isDark = themeCubit.isDarkMode;

    return Text(
      '$m:$s',
      style: TextStylesManager.bold12.copyWith(
        color: isDark
            ? ColorsManager.darkTextSecondary
            : ColorsManager.lightTextSecondary,
      ),
    );
  }
}
