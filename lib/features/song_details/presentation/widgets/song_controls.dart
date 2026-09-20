import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';
import 'package:pulse/core/utils/cubit/home/home_state.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';
import 'package:pulse/core/utils/cubit/theme/theme_state.dart';
import 'package:pulse/features/song_details/presentation/widgets/control_side_button.dart';
import 'package:pulse/features/song_details/presentation/widgets/play_pause_button.dart';

class SongControls extends StatelessWidget {
  final String songPath;

  const SongControls({super.key, required this.songPath});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (_, state) =>
          state is ThemeChangeThemeState || state is ThemeLanguageUpdatedState,
      builder: (context, _) {
        final theme = ThemeCubit.get(context);
        final home = HomeCubit.get(context);
        final isDark = theme.isDarkMode;

        return BlocBuilder<HomeCubit, HomeStates>(
          buildWhen: (_, state) =>
              state is HomeWaveColorUpdated ||
              state is HomePlayerPlayState ||
              state is HomePlayerPauseState ||
              state is HomePlayerStopState ||
              state is HomePlayerNextState ||
              state is HomePlayerPreviousState ||
              state is HomeShuffleChanged,
          builder: (context, _) {
            final auraColor = home.waveColor ?? ColorsManager.primary;

            return StreamBuilder<PlaybackState>(
              stream: home.playbackStateStream,
              builder: (context, snapshot) {
                final playing = snapshot.data?.playing ?? false;
                final repeatMode =
                    snapshot.data?.repeatMode ?? AudioServiceRepeatMode.none;
                final shuffleMode =
                    snapshot.data?.shuffleMode ?? AudioServiceShuffleMode.none;

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final isCompact = constraints.maxWidth < 360;
                    final sideButtonSize = isCompact ? 40.0 : 52.0;
                    final controlSize = isCompact ? 36.0 : 48.0;
                    final iconSize = isCompact ? 30.0 : 38.0;

                    return Row(
                      children: [
                        ControlSideButton(
                          icon: shuffleMode == AudioServiceShuffleMode.all
                              ? Icons.shuffle_on_rounded
                              : Icons.shuffle_rounded,
                          isActive: shuffleMode == AudioServiceShuffleMode.all,
                          isCompact: isCompact,
                          onTap: () => home.toggleShuffle(),
                          activeColor: auraColor,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => home.playPrevious(),
                                constraints: BoxConstraints.tightFor(
                                  width: controlSize,
                                  height: controlSize,
                                ),
                                padding: EdgeInsets.zero,
                                iconSize: iconSize,
                                icon: Icon(
                                  Icons.skip_previous_rounded,
                                  color: isDark
                                      ? ColorsManager.darkTextPrimary
                                      : ColorsManager.lightTextPrimary,
                                ),
                              ),
                              Container(width: isCompact ? 4 : 12),
                              PlayPauseButton(
                                playing: playing,
                                songPath: songPath,
                                auraColor: auraColor,
                                size: isCompact ? 58 : 72,
                              ),
                              Container(width: isCompact ? 4 : 12),
                              IconButton(
                                onPressed: () => home.playNext(),
                                constraints: BoxConstraints.tightFor(
                                  width: controlSize,
                                  height: controlSize,
                                ),
                                padding: EdgeInsets.zero,
                                iconSize: iconSize,
                                icon: Icon(
                                  Icons.skip_next_rounded,
                                  color: isDark
                                      ? ColorsManager.darkTextPrimary
                                      : ColorsManager.lightTextPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: sideButtonSize,
                          height: sideButtonSize,
                          child: ControlSideButton(
                            icon: repeatMode == AudioServiceRepeatMode.one
                                ? Icons.repeat_one_rounded
                                : Icons.repeat_rounded,
                            isActive: repeatMode != AudioServiceRepeatMode.none,
                            isCompact: isCompact,
                            onTap: () => home.cycleRepeatMode(),
                            activeColor: auraColor,
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
      },
    );
  }
}
