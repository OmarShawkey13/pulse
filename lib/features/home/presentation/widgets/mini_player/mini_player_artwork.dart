import 'package:flutter/material.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart' hide SongModel;
import 'package:pulse/core/models/music_model.dart';
import 'package:pulse/core/theme/colors.dart';

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
        nullArtworkWidget: _buildPlaceholder(),
        errorBuilder: (context, exception, _) => _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: ColorsManager.darkTextSecondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.music_note_rounded,
        color: ColorsManager.lightSurface.withValues(alpha: 0.7),
        size: size * 0.5,
      ),
    );
  }
}
