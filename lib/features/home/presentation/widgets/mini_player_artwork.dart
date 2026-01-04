import 'package:flutter/material.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart' hide SongModel;
import 'package:pulse/core/models/song_model.dart';

class MiniPlayerArtwork extends StatelessWidget {
  final SongModel song;

  const MiniPlayerArtwork({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      id: song.id,
      type: ArtworkType.AUDIO,
      artworkHeight: 50,
      artworkWidth: 50,
      artworkFit: BoxFit.cover,
      artworkBorder: BorderRadius.circular(8),
      nullArtworkWidget: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.music_note, color: Colors.white),
      ),
    );
  }
}
