import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/models/music_model.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';
import 'package:pulse/core/utils/cubit/home/home_state.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';
import 'package:pulse/core/utils/cubit/theme/theme_state.dart';
import 'package:pulse/features/song_details/presentation/widgets/song_controls.dart';
import 'package:pulse/features/song_details/presentation/widgets/song_favorite_button.dart';
import 'package:pulse/features/song_details/presentation/widgets/song_seek_bar.dart';
import 'package:pulse/features/song_details/presentation/widgets/song_title_section.dart';

class SongDetailsGlassCard extends StatelessWidget {
  final MusicModel song;

  const SongDetailsGlassCard({
    super.key,
    required this.song,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (_, state) =>
          state is ThemeChangeThemeState || state is ThemeLanguageUpdatedState,
      builder: (context, _) {
        final isDark = ThemeCubit.get(context).isDarkMode;

        return BlocBuilder<HomeCubit, HomeStates>(
          buildWhen: (_, state) =>
              state is HomeFavoriteToggledState ||
              state is HomePlayerPlayState ||
              state is HomePlayerNextState ||
              state is HomePlayerPreviousState ||
              state is HomePlayerStopState,
          builder: (context, _) {
            final home = HomeCubit.get(context);
            final isCompact = MediaQuery.sizeOf(context).width < 360;

            return RepaintBoundary(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(isCompact ? 24 : 32),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isCompact ? 16 : 24,
                      vertical: isCompact ? 20 : 28,
                    ),
                    decoration: BoxDecoration(
                      color:
                          (isDark
                                  ? ColorsManager.darkSurface
                                  : ColorsManager.lightSurface)
                              .withValues(alpha: isDark ? 0.05 : 0.3),
                      borderRadius: BorderRadius.circular(isCompact ? 28 : 40),
                      boxShadow: [
                        BoxShadow(
                          color: ColorsManager.black.withValues(
                            alpha: isDark ? 0.18 : 0.04,
                          ),
                          blurRadius: isCompact ? 24 : 32,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(
                        color: ColorsManager.lightSurface.withValues(
                          alpha: isDark ? 0.03 : 0.15,
                        ),
                        width: 0.5,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(child: SongTitleSection(song: song)),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: SongFavoriteButton(
                                isFav: home.isSongFavorite(song.id),
                                isDark: isDark,
                                onPressed: () => home.toggleFavorite(song),
                              ),
                            ),
                          ],
                        ),
                        Container(height: isCompact ? 18 : 24),
                        const SongSeekBar(),
                        Container(height: isCompact ? 12 : 16),
                        SongControls(songPath: song.path),
                      ],
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
