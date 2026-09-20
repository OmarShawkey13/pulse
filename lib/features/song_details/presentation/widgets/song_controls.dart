import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/utils/constants/spacing.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';
import 'package:pulse/core/utils/cubit/home/home_state.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';
import 'package:pulse/features/song_details/presentation/widgets/control_side_button.dart';
import 'package:pulse/features/song_details/presentation/widgets/play_pause_button.dart';

class SongControls extends StatelessWidget {
  final String songPath;

  const SongControls({super.key, required this.songPath});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeCubit.get(context);
    final home = HomeCubit.get(context);
    final isDark = theme.isDarkMode;

    return BlocBuilder<HomeCubit, HomeStates>(
      buildWhen: (prev, curr) =>
          curr is HomeWaveColorUpdated ||
          curr is HomePlayerPlayState ||
          curr is HomePlayerPauseState ||
          curr is HomePlayerNextState ||
          curr is HomePlayerPreviousState ||
          curr is HomeShuffleChanged,
      builder: (context, state) {
        final auraColor = home.waveColor ?? ColorsManager.primary;

        return StreamBuilder<PlaybackState>(
          stream: home.playbackStateStream,
          builder: (context, snapshot) {
            final playing = snapshot.data?.playing ?? false;
            final repeatMode =
                snapshot.data?.repeatMode ?? AudioServiceRepeatMode.none;
            final shuffleMode =
                snapshot.data?.shuffleMode ?? AudioServiceShuffleMode.none;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Shuffle Button
                ControlSideButton(
                  icon: shuffleMode == AudioServiceShuffleMode.all
                      ? Icons.shuffle_on_rounded
                      : Icons.shuffle_rounded,
                  isActive: shuffleMode == AudioServiceShuffleMode.all,
                  onTap: home.toggleShuffle,
                  activeColor: auraColor,
                ),

                // Playback Controls
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: home.playPrevious,
                        iconSize: 38, // Reduced size to prevent overflow
                        icon: Icon(
                          Icons.skip_previous_rounded,
                          color: isDark
                              ? ColorsManager.darkTextPrimary
                              : ColorsManager.lightTextPrimary,
                        ),
                      ),
                      horizontalSpace12, // Reduced spacing
                      PlayPauseButton(
                        playing: playing,
                        songPath: songPath,
                        auraColor: auraColor,
                      ),
                      horizontalSpace12, // Reduced spacing
                      IconButton(
                        onPressed: home.playNext,
                        iconSize: 38, // Reduced size
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

                // Repeat Button
                ControlSideButton(
                  icon: repeatMode == AudioServiceRepeatMode.one
                      ? Icons.repeat_one_rounded
                      : Icons.repeat_rounded,
                  isActive: repeatMode != AudioServiceRepeatMode.none,
                  onTap: home.cycleRepeatMode,
                  activeColor: auraColor,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
