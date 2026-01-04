import 'package:flutter/material.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart' hide SongModel;
import 'package:pulse/core/models/song_model.dart';
import 'package:pulse/core/utils/cubit/home_cubit.dart';

class SongItem extends StatelessWidget {
  final SongModel song;
  final bool isPlaying;
  final bool loadArtwork;

  const SongItem({
    super.key,
    required this.song,
    required this.isPlaying,
    this.loadArtwork = true,
  });

  @override
  Widget build(BuildContext context) {
    // Optimized for performance: Removed nested BlocBuilder
    final primaryColor = Theme.of(context).primaryColor;
    final cardColor = Theme.of(context).cardTheme.color;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isPlaying ? primaryColor.withValues(alpha: 0.1) : cardColor,
        borderRadius: BorderRadius.circular(16),
        border: isPlaying
            ? Border.all(color: primaryColor.withValues(alpha: 0.5))
            : null,
      ),
      child: ListTile(
        leading: _LeadingIcon(
          isPlaying: isPlaying,
          songId: song.id,
          loadArtwork: loadArtwork,
        ),
        title: Text(
          song.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          song.artist,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: _PlayPauseButton(
          isPlaying: isPlaying,
          onTap: () {
            if (isPlaying) {
              homeCubit.pauseSong();
            } else {
              homeCubit.playSong(song.path);
            }
          },
        ),
        onTap: () {
          homeCubit.playSong(song.path);
        },
      ),
    );
  }
}

class _LeadingIcon extends StatelessWidget {
  final bool isPlaying;
  final int songId;
  final bool loadArtwork;

  const _LeadingIcon({
    required this.isPlaying,
    required this.songId,
    required this.loadArtwork,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: isPlaying ? primaryColor : Colors.grey.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: loadArtwork
            ? QueryArtworkWidget(
                id: songId,
                type: ArtworkType.AUDIO,
                artworkHeight: 48,
                artworkWidth: 48,
                artworkFit: BoxFit.cover,
                nullArtworkWidget: Icon(
                  isPlaying ? Icons.graphic_eq : Icons.music_note_rounded,
                  color: isPlaying ? Colors.white : Colors.grey,
                ),
              )
            : Icon(
                isPlaying ? Icons.graphic_eq : Icons.music_note_rounded,
                color: isPlaying ? Colors.white : Colors.grey,
              ),
      ),
    );
  }
}

class _PlayPauseButton extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onTap;

  const _PlayPauseButton({
    required this.isPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return IconButton(
      onPressed: onTap,
      icon: Icon(
        isPlaying ? Icons.pause_circle_filled : Icons.play_circle_outline,
        size: 30,
        color: isPlaying ? primaryColor : Colors.grey.withValues(alpha: 0.6),
      ),
    );
  }
}
