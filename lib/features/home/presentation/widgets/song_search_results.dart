import 'package:flutter/material.dart';
import 'package:pulse/core/models/music_model.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/utils/constants/constants.dart';
import 'package:pulse/core/utils/constants/spacing.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';
import 'package:pulse/features/home/presentation/widgets/song_list/song_item.dart';

class SongSearchResults extends StatelessWidget {
  final List<MusicModel> songs;
  final String query;

  const SongSearchResults({
    super.key,
    required this.songs,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    final search = query.toLowerCase();
    final suggestions = songs.where((song) {
      return song.title.toLowerCase().contains(search) ||
          song.artist.toLowerCase().contains(search);
    }).toList();

    if (suggestions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 80,
              color: ColorsManager.primary.withValues(alpha: 0.5),
            ),
            verticalSpace16,
            Text(
              appTranslation().get('no_search_results'),
              style: TextStylesManager.medium18,
            ),
          ],
        ),
      );
    }

    final home = HomeCubit.get(context);
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10, bottom: 100),
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final song = suggestions[index];
        return StreamBuilder(
          stream: home.audioHandler.mediaItem,
          builder: (context, snapshot) {
            final isPlaying = snapshot.data?.id == song.path;
            return SongItem(
              song: song,
              isPlaying: isPlaying,
              queue: suggestions.map((e) => e.path).toList(),
            );
          },
        );
      },
    );
  }
}
