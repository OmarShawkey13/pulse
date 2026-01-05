import 'package:flutter/material.dart';
import 'package:pulse/core/models/song_model.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/utils/constants/spacing.dart';
import 'package:pulse/features/home/presentation/widgets/mini_player_artwork.dart';
import 'package:pulse/features/home/presentation/widgets/mini_player_controls.dart';

class MiniPlayerContent extends StatelessWidget {
  final SongModel song;

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
        12,
        16,
        bottomPadding > 0 ? bottomPadding : 12,
      ),
      child: Row(
        children: [
          MiniPlayerArtwork(song: song),
          horizontalSpace12,
          Expanded(child: _SongInfo(song: song)),
          MiniPlayerControls(
            songPath: song.path,
          ),
        ],
      ),
    );
  }
}

class _SongInfo extends StatelessWidget {
  final SongModel song;

  const _SongInfo({required this.song});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          song.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStylesManager.bold14,
        ),
        verticalSpace2,
        Text(
          song.artist,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStylesManager.regular12.copyWith(
            color: Colors.grey.shade400,
          ),
        ),
      ],
    );
  }
}
