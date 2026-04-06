import 'package:flutter/material.dart';
import 'package:pulse/features/home/presentation/widgets/playlists/playlist_card.dart';

class PlaylistsGrid extends StatelessWidget {
  final List<Map<String, dynamic>> playlists;
  final bool isDark;

  const PlaylistsGrid({
    super.key,
    required this.playlists,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.82,
      ),
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        final playlist = playlists[index];
        return PlaylistCard(
          playlist: playlist,
          isDark: isDark,
        );
      },
    );
  }
}
