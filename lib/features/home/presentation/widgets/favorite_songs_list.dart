import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/utils/constants/constants.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';
import 'package:pulse/core/utils/cubit/home/home_state.dart';
import 'package:pulse/features/home/presentation/widgets/song_list/song_item.dart';

class FavoriteSongsList extends StatelessWidget {
  const FavoriteSongsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      buildWhen: (_, state) =>
          state is HomePlayerPlayState ||
          state is HomePlayerPauseState ||
          state is HomePlayerStopState ||
          state is HomePlayerNextState ||
          state is HomePlayerPreviousState ||
          state is HomeFavoritesLoadedState ||
          state is HomeFavoriteToggledState,
      builder: (context, state) {
        final home = HomeCubit.get(context);
        if (home.favorites.isEmpty) {
          return Center(
            child: Text(
              appTranslation().get('no_favorites_yet'),
              style: TextStylesManager.medium16,
            ),
          );
        }
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 100),
          itemCount: home.favorites.length,
          itemBuilder: (_, index) {
            final song = home.favorites[index];
            final isPlaying = home.currentSongPath == song.path;
            return SongItem(
              song: song,
              isPlaying: isPlaying,
              queue: home.favorites.map((e) => e.path).toList(),
            );
          },
        );
      },
    );
  }
}
