import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/utils/constants/spacing.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';
import 'package:pulse/core/utils/cubit/home/home_state.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';
import 'package:pulse/features/song_details/presentation/widgets/song_artwork.dart';
import 'package:pulse/features/song_details/presentation/widgets/song_controls.dart';
import 'package:pulse/features/song_details/presentation/widgets/song_seek_bar.dart';
import 'package:pulse/features/song_details/presentation/widgets/song_title_section.dart';

class SongDetailsContent extends StatelessWidget {
  const SongDetailsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      buildWhen: (_, state) =>
          state is HomePlayerPlayState ||
          state is HomePlayerPauseState ||
          state is HomePlayerNextState ||
          state is HomePlayerPreviousState ||
          state is HomeFavoriteToggledState ||
          state is HomeShuffleChanged,
      builder: (context, state) {
        final cubit = homeCubit;
        final currentPath = cubit.currentSongPath;

        if (currentPath == null || cubit.songs.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final song = cubit.songs.firstWhere(
          (e) => e.path == currentPath,
          orElse: () => cubit.songs.first,
        );

        final isFav = cubit.isSongFavorite(song.id);
        final isDark = themeCubit.isDarkMode;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 1. Artwork Section
              const SongArtwork(),

              // 2. Info & Controls Section with Glassmorphism-like card
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  color: (isDark ? ColorsManager.darkSurface : ColorsManager.lightSurface).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: (isDark ? ColorsManager.darkDivider : ColorsManager.lightDivider).withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SongTitleSection(song: song),
                        ),
                        IconButton.filledTonal(
                          onPressed: () => cubit.toggleFavorite(song),
                          style: IconButton.styleFrom(
                            backgroundColor: isFav
                                ? ColorsManager.primary.withValues(alpha: 0.2)
                                : (isDark ? ColorsManager.darkCard : ColorsManager.lightDivider)
                                      .withValues(alpha: 0.5),
                          ),
                          icon: Icon(
                            isFav
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: isFav
                                ? ColorsManager.primary
                                : (isDark ? ColorsManager.darkTextSecondary : ColorsManager.lightTextSecondary),
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                    verticalSpace32,
                    const SongSeekBar(),
                    verticalSpace20,
                    SongControls(songPath: song.path),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
