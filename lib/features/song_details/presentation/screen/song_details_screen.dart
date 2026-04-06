import 'package:flutter/material.dart';
import 'package:pulse/features/song_details/presentation/widgets/animated_music_aura.dart';
import 'package:pulse/features/song_details/presentation/widgets/song_details_app_bar.dart';
import 'package:pulse/features/song_details/presentation/widgets/song_details_content.dart';

class SongDetailsScreen extends StatelessWidget {
  final VoidCallback? onClose;

  const SongDetailsScreen({super.key, this.onClose});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: SongDetailsAppBar(onClose: onClose),
      body: const Stack(
        fit: StackFit.expand,
        children: [
          MusicAura(),
          SongDetailsContent(),
        ],
      ),
    );
  }
}
