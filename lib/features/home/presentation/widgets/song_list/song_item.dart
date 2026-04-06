import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/models/music_model.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/utils/constants/spacing.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';
import 'package:pulse/core/utils/cubit/theme/theme_state.dart';
import 'package:pulse/features/home/presentation/widgets/song_list/song_artwork.dart';
import 'package:pulse/features/home/presentation/widgets/song_list/song_info.dart';
import 'package:pulse/features/home/presentation/widgets/song_list/song_playing_indicator.dart';

class SongItem extends StatelessWidget {
  final MusicModel song;
  final bool isPlaying;
  final bool loadArtwork;
  final List<String>? queue;

  const SongItem({
    super.key,
    required this.song,
    required this.isPlaying,
    this.loadArtwork = true,
    this.queue,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final isDark = themeCubit.isDarkMode;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: AnimatedScale(
            scale: isPlaying ? 1.02 : 1.0,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: isPlaying
                    ? LinearGradient(
                        colors: [
                          ColorsManager.primary.withValues(alpha: 0.15),
                          ColorsManager.primary.withValues(alpha: 0.05),
                          isDark
                              ? Colors.white.withValues(alpha: 0.02)
                              : Colors.black.withValues(alpha: 0.01),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isPlaying
                    ? null
                    : (isDark
                              ? ColorsManager.darkCard
                              : ColorsManager.lightSurface)
                          .withValues(alpha: 0.4),
                border: Border.all(
                  color: isPlaying
                      ? ColorsManager.primary.withValues(alpha: 0.2)
                      : Colors.transparent,
                  width: 1,
                ),
                boxShadow: isPlaying
                    ? [
                        BoxShadow(
                          color: ColorsManager.primary.withValues(alpha: 0.08),
                          blurRadius: 24,
                          spreadRadius: 0,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => homeCubit.playSong(song.path, queue: queue),
                    highlightColor: ColorsManager.primary.withValues(
                      alpha: 0.1,
                    ),
                    splashColor: ColorsManager.primary.withValues(alpha: 0.05),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          SongArtwork(
                            songId: song.id,
                            isPlaying: isPlaying,
                            loadArtwork: loadArtwork,
                          ),
                          horizontalSpace14,
                          Expanded(
                            child: SongInfo(
                              title: song.title,
                              artist: song.artist,
                              isPlaying: isPlaying,
                            ),
                          ),
                          _buildTrailingAction(isDark),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrailingAction(bool isDark) {
    if (isPlaying) {
      return const SongPlayingIndicator();
    }
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.play_arrow_rounded,
        color:
            (isDark
                    ? ColorsManager.darkTextSecondary
                    : ColorsManager.lightTextSecondary)
                .withValues(alpha: 0.6),
        size: 22,
      ),
    );
  }
}
