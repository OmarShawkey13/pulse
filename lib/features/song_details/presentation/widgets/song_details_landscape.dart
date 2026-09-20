import 'package:flutter/material.dart';
import 'package:pulse/core/models/music_model.dart';
import 'package:pulse/features/song_details/presentation/widgets/song_artwork.dart';
import 'package:pulse/features/song_details/presentation/widgets/song_details_glass_card.dart';

class SongDetailsLandscape extends StatelessWidget {
  final MusicModel song;
  final double width;

  const SongDetailsLandscape({
    super.key,
    required this.song,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          flex: 4,
          child: Center(child: SongArtwork()),
        ),
        Container(width: width * 0.05),
        Expanded(
          flex: 5,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SongDetailsGlassCard(song: song),
          ),
        ),
      ],
    );
  }
}
