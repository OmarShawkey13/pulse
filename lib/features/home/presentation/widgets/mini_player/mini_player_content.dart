import 'package:flutter/material.dart';
import 'package:pulse/core/models/music_model.dart';
import 'package:pulse/core/utils/constants/spacing.dart';
import 'package:pulse/features/home/presentation/widgets/mini_player/mini_player_artwork.dart';
import 'package:pulse/features/home/presentation/widgets/mini_player/mini_player_controls.dart';
import 'package:pulse/features/home/presentation/widgets/mini_player/mini_player_song_info.dart';

class MiniPlayerContent extends StatelessWidget {
  final MusicModel song;

  const MiniPlayerContent({
    super.key,
    required this.song,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        8,
        16,
        bottomPadding > 0 ? bottomPadding : 12,
      ),
      child: Row(
        children: [
          MiniPlayerArtwork(song: song),
          horizontalSpace12,
          Expanded(child: MiniPlayerSongInfo(song: song)),
          const MiniPlayerControls(),
        ],
      ),
    );
  }
}
