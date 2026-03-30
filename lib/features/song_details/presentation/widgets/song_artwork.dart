import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';
import 'package:pulse/core/utils/cubit/home/home_state.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';

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
      duration: const Duration(seconds: 3),
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
        final song = cubit.songs.firstWhere(
          (e) => e.path == currentPath,
          orElse: () => cubit.songs.first,
        );
        final auraColor = cubit.waveColor ?? ColorsManager.primary;
        final isDark = themeCubit.isDarkMode;

        return Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Animated Aura Glow behind the artwork
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Container(
                    height:
                        MediaQuery.sizeOf(context).width * 0.75 +
                        (_controller.value * 25),
                    width:
                        MediaQuery.sizeOf(context).width * 0.75 +
                        (_controller.value * 25),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: auraColor.withValues(alpha: 0.3),
                          blurRadius: 40 + (_controller.value * 20),
                          spreadRadius: 10 + (_controller.value * 10),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Main Artwork
              Hero(
                tag: 'song_artwork_${song.id}',
                child: Container(
                  height: MediaQuery.sizeOf(context).width * 0.8,
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: QueryArtworkWidget(
                      id: song.id,
                      type: ArtworkType.AUDIO,
                      artworkHeight: double.infinity,
                      artworkWidth: double.infinity,
                      artworkFit: BoxFit.cover,
                      quality: 100,
                      size: 1000,
                      format: ArtworkFormat.PNG,
                      artworkQuality: FilterQuality.high,
                      nullArtworkWidget: Container(
                        color: isDark
                            ? ColorsManager.darkCard
                            : ColorsManager.lightDivider,
                        child: Icon(
                          Icons.music_note_rounded,
                          size: 100,
                          color: ColorsManager.primary.withValues(alpha: 0.5),
                        ),
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
}
