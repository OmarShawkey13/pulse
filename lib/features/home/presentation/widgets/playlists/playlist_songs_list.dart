import 'package:flutter/material.dart';
import 'package:pulse/core/models/music_model.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';
import 'package:pulse/features/home/presentation/widgets/song_list/song_item.dart';

class PlaylistSongsList extends StatelessWidget {
  final List<MusicModel> songs;

  const PlaylistSongsList({super.key, required this.songs});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 100),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final song = songs[index];
            return StreamBuilder(
              stream: homeCubit.audioHandler.mediaItem,
              builder: (context, snapshot) {
                final isPlaying = snapshot.data?.id == song.path;
                return SongItem(
                  song: song,
                  isPlaying: isPlaying,
                  queue: songs.map((e) => e.path).toList(),
                );
              },
            );
          },
          childCount: songs.length,
        ),
      ),
    );
  }
}
