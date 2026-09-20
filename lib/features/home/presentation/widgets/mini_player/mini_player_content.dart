import 'package:flutter/material.dart';
import 'package:pulse/core/models/music_model.dart';
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
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 360;
        final horizontalPadding = isCompact ? 12.0 : 16.0;
        final artworkSize = isCompact ? 42.0 : 48.0;
        final contentBottomPadding = bottomPadding > 0 ? bottomPadding : 12.0;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            8,
            horizontalPadding,
            contentBottomPadding,
          ),
          child: Row(
            children: [
              MiniPlayerArtwork(
                song: song,
                size: artworkSize,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isCompact ? 8 : 12,
                  ),
                  child: MiniPlayerSongInfo(song: song),
                ),
              ),
              MiniPlayerControls(isCompact: isCompact),
            ],
          ),
        );
      },
    );
  }
}
