import 'package:flutter/material.dart';
import 'package:pulse/core/theme/colors.dart';

class PlaylistCardPlaceholder extends StatelessWidget {
  const PlaylistCardPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(
        Icons.music_note_rounded,
        size: 45,
        color: ColorsManager.white,
      ),
    );
  }
}
