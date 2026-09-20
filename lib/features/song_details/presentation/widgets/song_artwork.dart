import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';
import 'package:pulse/core/utils/cubit/home/home_state.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';
import 'package:pulse/core/utils/cubit/theme/theme_state.dart';
import 'package:pulse/features/song_details/presentation/widgets/song_artwork_placeholder.dart';

class SongArtwork extends StatefulWidget {
  const SongArtwork({super.key});

  @override
  State<SongArtwork> createState() => _SongArtworkState();
}

class _SongArtworkState extends State<SongArtwork>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (_, state) =>
          state is ThemeChangeThemeState || state is ThemeLanguageUpdatedState,
      builder: (context, _) => BlocBuilder<HomeCubit, HomeStates>(
        buildWhen: (_, state) =>
            state is HomePlayerPlayState ||
            state is HomePlayerNextState ||
            state is HomePlayerPreviousState ||
            state is HomePlayerStopState ||
            state is HomeLoadSongsSuccessState ||
            state is HomeWaveColorUpdated,
        builder: (context, state) {
          final cubit = HomeCubit.get(context);
          final currentPath = cubit.currentSongPath;

          if (currentPath == null || cubit.songs.isEmpty) {
            return const SizedBox.shrink();
          }

          final song = cubit.songs.firstWhere(
            (e) => e.path == currentPath,
            orElse: () => cubit.songs.first,
          );
          final auraColor = cubit.waveColor ?? ColorsManager.primary;
          final isDark = ThemeCubit.get(context).isDarkMode;

          return LayoutBuilder(
            builder: (context, constraints) {
              final screenSize = MediaQuery.sizeOf(context);
              final availableWidth = constraints.hasBoundedWidth
                  ? constraints.maxWidth
                  : screenSize.width;
              final availableHeight =
                  constraints.hasBoundedHeight && constraints.maxHeight > 0
                  ? constraints.maxHeight
                  : availableWidth;
              final artworkSize = math.min(availableWidth, availableHeight);

              return Center(
                child: SizedBox.square(
                  dimension: artworkSize,
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, _) {
                          final pulse = _controller.value;
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: artworkSize * (1.05 + pulse * 0.08),
                                width: artworkSize * (1.05 + pulse * 0.08),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: auraColor.withValues(alpha: 0.12),
                                      blurRadius: artworkSize * 0.16,
                                      spreadRadius: artworkSize * 0.02,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: artworkSize * 0.9,
                                width: artworkSize * 0.9,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: auraColor.withValues(alpha: 0.28),
                                      blurRadius: artworkSize * 0.11,
                                      spreadRadius: -artworkSize * 0.01,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) => Transform.translate(
                          offset: Offset(
                            0,
                            -artworkSize * 0.025 * _controller.value,
                          ),
                          child: child,
                        ),
                        child: Hero(
                          tag: 'artwork_${song.id}',
                          child: Container(
                            height: artworkSize,
                            width: artworkSize,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                artworkSize * 0.1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: ColorsManager.black.withValues(
                                    alpha: 0.32,
                                  ),
                                  blurRadius: artworkSize * 0.08,
                                  offset: Offset(0, artworkSize * 0.06),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                artworkSize * 0.1,
                              ),
                              child: QueryArtworkWidget(
                                id: song.id,
                                type: ArtworkType.AUDIO,
                                artworkHeight: artworkSize,
                                artworkWidth: artworkSize,
                                artworkFit: BoxFit.cover,
                                quality: 80,
                                size: artworkSize.round(),
                                format: ArtworkFormat.PNG,
                                nullArtworkWidget: SongArtworkPlaceholder(
                                  isDark: isDark,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
