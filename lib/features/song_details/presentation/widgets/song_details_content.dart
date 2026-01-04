import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/utils/constants/spacing.dart';
import 'package:pulse/core/utils/cubit/home_cubit.dart';
import 'package:pulse/core/utils/cubit/home_state.dart';
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
          state is HomePlayerPreviousState,
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

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const Spacer(),
                    const SongArtwork(),
                    const Spacer(),
                    SongTitleSection(song: song),
                    verticalSpace32,
                    const SongSeekBar(),
                    verticalSpace24,
                    SongControls(
                      songPath: song.path,
                    ),
                    const Spacer(flex: 2),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
