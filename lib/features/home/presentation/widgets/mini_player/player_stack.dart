import 'package:flutter/material.dart';
import 'package:pulse/core/models/music_model.dart';
import 'package:pulse/features/home/presentation/widgets/mini_player/mini_player_content.dart';
import 'package:pulse/features/song_details/presentation/screen/song_details_screen.dart';

class PlayerStack extends StatelessWidget {
  final double value;
  final double minHeight;
  final MusicModel song;
  final VoidCallback onClose;

  const PlayerStack({
    super.key,
    required this.value,
    required this.minHeight,
    required this.song,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (value < 0.95)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: minHeight,
            child: Opacity(
              opacity: (1 - value * 5).clamp(0.0, 1.0),
              child: IgnorePointer(
                ignoring: value > 0.1,
                child: MiniPlayerContent(song: song),
              ),
            ),
          ),
        if (value > 0.05)
          Positioned.fill(
            child: Opacity(
              opacity: ((value - 0.05) * 1.05).clamp(0.0, 1.0),
              child: IgnorePointer(
                ignoring: value < 0.8,
                child: SongDetailsScreen(onClose: onClose),
              ),
            ),
          ),
      ],
    );
  }
}
