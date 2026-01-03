import 'package:flutter/material.dart';
import 'package:pulse/core/models/song_model.dart';
import 'package:pulse/core/utils/constants/spacing.dart';

class SongTitleSection extends StatelessWidget {
  final SongModel song;

  const SongTitleSection({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          song.title,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        verticalSpace8,
        Text(
          song.artist,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}
