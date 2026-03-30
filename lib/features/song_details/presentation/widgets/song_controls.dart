import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/utils/constants/spacing.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';

class SongControls extends StatelessWidget {
  final String songPath;

  const SongControls({super.key, required this.songPath});

  @override
  Widget build(BuildContext context) {
    final isDark = themeCubit.isDarkMode;
    final auraColor = ColorsManager.primary;

    return StreamBuilder<PlaybackState>(
      stream: homeCubit.playbackStateStream,
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
            _ControlSideButton(
              icon: shuffleMode == AudioServiceShuffleMode.all
                  ? Icons.shuffle_on_rounded
                  : Icons.shuffle_rounded,
              isActive: shuffleMode == AudioServiceShuffleMode.all,
              onTap: homeCubit.toggleShuffle,
            ),

            // Playback Controls
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: homeCubit.playPrevious,
                  iconSize: 42,
                  icon: Icon(
                    Icons.skip_previous_rounded,
                    color: isDark
                        ? ColorsManager.darkTextPrimary
                        : ColorsManager.lightTextPrimary,
                  ),
                ),
                horizontalSpace8,
                // Play/Pause Aura Button
                GestureDetector(
                  onTap: () => playing
                      ? homeCubit.pauseSong()
                      : homeCubit.playSong(songPath),
                  child: Container(
                    height: 85,
                    width: 85,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [auraColor, auraColor.withValues(alpha: 0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: auraColor.withValues(alpha: 0.4),
                          blurRadius: 25,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      size: 52,
                      color: ColorsManager.lightSurface,
                    ),
                  ),
                ),
                horizontalSpace8,
                IconButton(
                  onPressed: homeCubit.playNext,
                  iconSize: 42,
                  icon: Icon(
                    Icons.skip_next_rounded,
                    color: isDark
                        ? ColorsManager.darkTextPrimary
                        : ColorsManager.lightTextPrimary,
                  ),
                ),
              ],
            ),

            // Repeat Button
            _ControlSideButton(
              icon: repeatMode == AudioServiceRepeatMode.one
                  ? Icons.repeat_one_rounded
                  : Icons.repeat_rounded,
              isActive: repeatMode != AudioServiceRepeatMode.none,
              onTap: homeCubit.cycleRepeatMode,
            ),
          ],
        );
      },
    );
  }
}

class _ControlSideButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _ControlSideButton({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = themeCubit.isDarkMode;
    return IconButton.filledTonal(
      onPressed: onTap,
      style: IconButton.styleFrom(
        backgroundColor: isActive
            ? ColorsManager.primary.withValues(alpha: 0.2)
            : (isDark ? ColorsManager.darkCard : ColorsManager.lightDivider)
                .withValues(alpha: 0.3),
        foregroundColor: isActive
            ? ColorsManager.primary
            : (isDark
                ? ColorsManager.darkTextSecondary
                : ColorsManager.lightTextSecondary),
      ),
      icon: Icon(icon, size: 26),
    );
  }
}
