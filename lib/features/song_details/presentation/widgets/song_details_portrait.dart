import 'package:flutter/material.dart';
import 'package:pulse/core/models/music_model.dart';
import 'package:pulse/features/song_details/presentation/widgets/song_artwork.dart';
import 'package:pulse/features/song_details/presentation/widgets/song_details_glass_card.dart';

class SongDetailsPortrait extends StatelessWidget {
  final MusicModel song;

  const SongDetailsPortrait({
    super.key,
    required this.song,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final artworkWidth = (constraints.maxWidth * 0.78)
            .clamp(0.0, 320.0)
            .toDouble();

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: 12, bottom: 24),
          child: Column(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: artworkWidth,
                  maxHeight: artworkWidth,
                ),
                child: const AspectRatio(
                  aspectRatio: 1,
                  child: SongArtwork(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18),
                child: SongDetailsGlassCard(song: song),
              ),
            ],
          ),
        );
      },
    );
  }
}
