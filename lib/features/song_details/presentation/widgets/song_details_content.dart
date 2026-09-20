import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';
import 'package:pulse/core/utils/cubit/home/home_state.dart';
import 'package:pulse/features/song_details/presentation/widgets/song_details_landscape.dart';
import 'package:pulse/features/song_details/presentation/widgets/song_details_portrait.dart';

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
              state is HomePlayerPlayState ||
              state is HomePlayerNextState ||
              state is HomePlayerPreviousState ||
              state is HomePlayerStopState ||
              state is HomeLoadSongsSuccessState,
          builder: (context, state) {
            final cubit = HomeCubit.get(context);
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
                      ? SongDetailsLandscape(song: song, width: screenWidth)
                      : SongDetailsPortrait(song: song),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
