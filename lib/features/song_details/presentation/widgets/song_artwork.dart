import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';
import 'package:pulse/core/utils/cubit/home/home_state.dart';

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
    return BlocBuilder<HomeCubit, HomeStates>(
      buildWhen: (_, state) =>
          state is HomePlayerPlayState ||
          state is HomePlayerNextState ||
          state is HomePlayerPreviousState ||
          state is HomeWaveColorUpdated,
      builder: (context, state) {
        final cubit = homeCubit;
        final currentPath = cubit.currentSongPath;

        if (currentPath == null) return const SizedBox.shrink();

        final song = cubit.songs.firstWhere(
          (e) => e.path == currentPath,
          orElse: () => cubit.songs.first,
        );

        final auraColor = cubit.waveColor ?? ColorsManager.primary;
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Animated Aura Glow
              AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final size = MediaQuery.sizeOf(context).width * 0.72;
                  final pulse = _controller.value;
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer soft glow
                      Container(
                        height: size * (1.1 + (pulse * 0.1)),
                        width: size * (1.1 + (pulse * 0.1)),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: auraColor.withValues(alpha: 0.15),
                              blurRadius: 60 + (pulse * 20),
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      // Inner intense glow
                      Container(
                        height: size * 0.9,
                        width: size * 0.9,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: auraColor.withValues(alpha: 0.4),
                              blurRadius: 40 + (pulse * 30),
                              spreadRadius: -5,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),

              // Main Artwork with Floating Animation
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, -10 * _controller.value),
                    child: child,
                  );
                },
                child: Hero(
                  tag: 'artwork_${song.id}',
                  child: Container(
                    height: MediaQuery.sizeOf(context).width * 0.78,
                    width: MediaQuery.sizeOf(context).width * 0.78,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.4),
                          blurRadius: 30,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: QueryArtworkWidget(
                        id: song.id,
                        type: ArtworkType.AUDIO,
                        artworkHeight: double.infinity,
                        artworkWidth: double.infinity,
                        artworkFit: BoxFit.cover,
                        quality: 100,
                        size: 1000,
                        format: ArtworkFormat.PNG,
                        nullArtworkWidget: _buildPlaceholder(isDark),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlaceholder(bool isDark) {
    return Container(
      color: isDark ? ColorsManager.darkCard : ColorsManager.lightDivider,
      child: Icon(
        Icons.music_note_rounded,
        size: 80,
        color: ColorsManager.primary.withValues(alpha: 0.4),
      ),
    );
  }
}
