import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/models/music_model.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';
import 'package:pulse/core/utils/cubit/home/home_state.dart';
import 'package:pulse/features/song_details/presentation/widgets/song_artwork.dart';
import 'package:pulse/features/song_details/presentation/widgets/song_details_glass_card.dart';

class SongDetailsContent extends StatelessWidget {
  const SongDetailsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenHeight = constraints.maxHeight;
        final double screenWidth = constraints.maxWidth;
        final bool isLandscape = screenWidth > screenHeight;

        return BlocBuilder<HomeCubit, HomeStates>(
          buildWhen: (_, state) =>
              state is HomePlayerNextState ||
              state is HomePlayerPreviousState ||
              state is HomeLoadSongsSuccessState,
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

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.06,
                  ),
                  child: isLandscape
                      ? _SongDetailsLandscape(song: song, width: screenWidth)
                      : _SongDetailsPortrait(song: song, height: screenHeight),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _SongDetailsPortrait extends StatelessWidget {
  final MusicModel song;
  final double height;

  const _SongDetailsPortrait({required this.song, required this.height});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(flex: 2),
        const SongArtwork(),
        const Spacer(flex: 2),
        SongDetailsGlassCard(song: song),
        const Spacer(flex: 1),
      ],
    );
  }
}

class _SongDetailsLandscape extends StatelessWidget {
  final MusicModel song;
  final double width;

  const _SongDetailsLandscape({required this.song, required this.width});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          flex: 4,
          child: Center(child: SongArtwork()),
        ),
        SizedBox(width: width * 0.05),
        Expanded(
          flex: 5,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SongDetailsGlassCard(song: song),
          ),
        ),
      ],
    );
  }
}
