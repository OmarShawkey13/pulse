import 'package:flutter/material.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart' hide SongModel;
import 'package:pulse/core/models/music_model.dart';
import 'package:pulse/features/home/presentation/widgets/mini_player/mini_player_artwork_placeholder.dart';

class MiniPlayerArtwork extends StatelessWidget {
  final MusicModel song;
  final double size;

  const MiniPlayerArtwork({
    super.key,
    required this.song,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'artwork_${song.id}',
      child: QueryArtworkWidget(
        id: song.id,
        type: ArtworkType.AUDIO,
        artworkHeight: size,
        artworkWidth: size,
        artworkFit: BoxFit.cover,
        artworkBorder: BorderRadius.circular(8),
        nullArtworkWidget: MiniPlayerArtworkPlaceholder(size: size),
        errorBuilder: (context, exception, _) =>
            MiniPlayerArtworkPlaceholder(size: size),
      ),
    );
  }
}
