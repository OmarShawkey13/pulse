import 'package:flutter/material.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/features/home/presentation/widgets/song_list/song_item_default_artwork.dart';

class SongArtwork extends StatelessWidget {
  final int songId;
  final bool isPlaying;
  final bool loadArtwork;

  const SongArtwork({
    super.key,
    required this.songId,
    required this.isPlaying,
    required this.loadArtwork,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Subtle Glow behind artwork when playing
        if (isPlaying)
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: ColorsManager.primary.withValues(alpha: 0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),

        // Main Artwork
        Hero(
          tag: 'song_artwork_$songId',
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: isPlaying
                  ? Border.all(
                      color: ColorsManager.primary.withValues(alpha: 0.3),
                      width: 1.5,
                    )
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: loadArtwork
                  ? QueryArtworkWidget(
                      id: songId,
                      type: ArtworkType.AUDIO,
                      artworkHeight: 56,
                      artworkWidth: 56,
                      artworkFit: BoxFit.cover,
                      artworkBorder: BorderRadius.zero,
                      nullArtworkWidget: SongItemDefaultArtwork(
                        isPlaying: isPlaying,
                      ),
                    )
                  : SongItemDefaultArtwork(isPlaying: isPlaying),
            ),
          ),
        ),
      ],
    );
  }
}
