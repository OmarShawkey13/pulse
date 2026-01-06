import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/models/song_model.dart';
import 'package:pulse/core/utils/cubit/home_cubit.dart';
import 'package:pulse/core/utils/cubit/home_state.dart';

class SongControls extends StatelessWidget {
  final String songPath;

  const SongControls({
    super.key,
    required this.songPath,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = homeCubit;
    final primaryColor = Theme.of(context).primaryColor;

    return StreamBuilder<PlaybackState>(
      stream: cubit.playbackStateStream,
      builder: (context, snapshot) {
        final playing = snapshot.data?.playing ?? false;
        final repeatMode =
            snapshot.data?.repeatMode ?? AudioServiceRepeatMode.none;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 12,
          children: [
            IconButton(
              onPressed: cubit.cycleRepeatMode,
              icon: Icon(
                repeatMode == AudioServiceRepeatMode.one
                    ? Icons.repeat_one_rounded
                    : Icons.repeat_rounded,
                size: 30,
                color: repeatMode == AudioServiceRepeatMode.none
                    ? Colors.white
                    : primaryColor,
              ),
            ),
            IconButton(
              onPressed: cubit.playPrevious,
              icon: const Icon(
                Icons.skip_previous_rounded,
                size: 45,
                color: Colors.white,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () =>
                    playing ? cubit.pauseSong() : cubit.playSong(songPath),
                icon: Icon(
                  playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  size: 50,
                  color: primaryColor,
                ),
              ),
            ),
            IconButton(
              onPressed: cubit.playNext,
              icon: const Icon(
                Icons.skip_next_rounded,
                size: 45,
                color: Colors.white,
              ),
            ),
            BlocBuilder<HomeCubit, HomeStates>(
              buildWhen: (previous, current) =>
                  current is HomeFavoriteToggledState ||
                  current is HomeFavoritesLoadedState,
              builder: (context, state) {
                final song = cubit.songs.firstWhere(
                  (element) => element.path == songPath,
                  orElse: () => SongModel(
                    id: -1,
                    path: songPath,
                    title: 'Unknown',
                    artist: 'Unknown',
                  ),
                );
                final isFav = cubit.isSongFavorite(song.id);
                return IconButton(
                  onPressed: () {
                    if (song.id != -1) {
                      cubit.toggleFavorite(song);
                    }
                  },
                  icon: Icon(
                    isFav
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 30,
                    color: isFav ? primaryColor : Colors.white,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
