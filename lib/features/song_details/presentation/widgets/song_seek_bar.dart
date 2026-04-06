import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';
import 'package:pulse/core/utils/cubit/home/home_state.dart';
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

    return BlocBuilder<HomeCubit, HomeStates>(
      buildWhen: (prev, curr) => curr is HomeWaveColorUpdated,
      builder: (context, state) {
        final auraColor = homeCubit.waveColor ?? ColorsManager.primary;

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
                      data: SliderThemeData(
                        trackHeight: 2,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 7,
                          elevation: 4,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 16,
                        ),
                        activeTrackColor: auraColor,
                        inactiveTrackColor: auraColor.withValues(alpha: 0.1),
                        thumbColor: auraColor,
                        overlayColor: auraColor.withValues(alpha: 0.1),
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
                      padding: const EdgeInsets.symmetric(horizontal: 24),
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
