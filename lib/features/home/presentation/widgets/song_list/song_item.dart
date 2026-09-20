import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/models/music_model.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/utils/constants/spacing.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';
import 'package:pulse/core/utils/cubit/home/home_state.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';
import 'package:pulse/core/utils/cubit/theme/theme_state.dart';
import 'package:pulse/features/home/presentation/widgets/song_list/song_artwork.dart';
import 'package:pulse/features/home/presentation/widgets/song_list/song_info.dart';
import 'package:pulse/features/home/presentation/widgets/song_list/song_item_trailing_action.dart';

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
    return BlocSelector<HomeCubit, HomeStates, bool>(
      selector: (state) => HomeCubit.get(context).currentSongPath == song.path,
      builder: (context, currentIsPlaying) {
        return BlocBuilder<ThemeCubit, ThemeState>(
          buildWhen: (_, state) =>
              state is ThemeChangeThemeState ||
              state is ThemeLanguageUpdatedState,
          builder: (context, state) {
            final isDark = ThemeCubit.get(context).isDarkMode;
            final home = HomeCubit.get(context);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: AnimatedScale(
                scale: currentIsPlaying ? 1.02 : 1.0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: currentIsPlaying
                        ? LinearGradient(
                            colors: [
                              ColorsManager.primary.withValues(alpha: 0.15),
                              ColorsManager.primary.withValues(alpha: 0.05),
                              isDark
                                  ? ColorsManager.white.withValues(alpha: 0.02)
                                  : ColorsManager.black.withValues(alpha: 0.01),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: currentIsPlaying
                        ? null
                        : (isDark
                                  ? ColorsManager.darkCard
                                  : ColorsManager.lightSurface)
                              .withValues(alpha: 0.4),
                    border: Border.all(
                      color: currentIsPlaying
                          ? ColorsManager.primary.withValues(alpha: 0.2)
                          : ColorsManager.transparent,
                      width: 1,
                    ),
                    boxShadow: currentIsPlaying
                        ? [
                            BoxShadow(
                              color: ColorsManager.primary.withValues(
                                alpha: 0.08,
                              ),
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
                      color: ColorsManager.transparent,
                      child: InkWell(
                        onTap: () => home.playSong(song.path, queue: queue),
                        highlightColor: ColorsManager.primary.withValues(
                          alpha: 0.1,
                        ),
                        splashColor: ColorsManager.primary.withValues(
                          alpha: 0.05,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              SongArtwork(
                                songId: song.id,
                                isPlaying: currentIsPlaying,
                                loadArtwork: loadArtwork,
                              ),
                              horizontalSpace14,
                              Expanded(
                                child: SongInfo(
                                  title: song.title,
                                  artist: song.artist,
                                  isPlaying: currentIsPlaying,
                                ),
                              ),
                              SongItemTrailingAction(
                                isDark: isDark,
                                isPlaying: currentIsPlaying,
                              ),
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
      },
    );
  }
}
