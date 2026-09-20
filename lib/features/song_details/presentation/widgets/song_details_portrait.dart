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
    return Column(
      children: [
        const Spacer(flex: 2),
        const SongArtwork(),
        const Spacer(flex: 2),
        SongDetailsGlassCard(song: song),
        const Spacer(flex: 1),
      ],
    );
  }
}
