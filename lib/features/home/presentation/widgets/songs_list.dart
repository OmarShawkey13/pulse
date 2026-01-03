import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/utils/cubit/home_cubit.dart';
import 'package:pulse/core/utils/cubit/home_state.dart';
import 'package:pulse/features/home/presentation/widgets/song_item.dart';

class SongsList extends StatelessWidget {
  const SongsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      buildWhen: (_, state) =>
          state is HomePlayerPlayState ||
          state is HomePlayerPauseState ||
          state is HomePlayerStopState ||
          state is HomePlayerNextState ||
          state is HomePlayerPreviousState,
      builder: (context, state) {
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 100),
          itemCount: homeCubit.songs.length,
          itemBuilder: (_, index) {
            final song = homeCubit.songs[index];
            final isPlaying = homeCubit.currentSongPath == song.path;
            return SongItem(
              song: song,
              isPlaying: isPlaying,
            );
          },
        );
      },
    );
  }
}
