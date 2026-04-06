import 'package:flutter/material.dart';
import 'package:pulse/core/models/music_model.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/utils/constants/primary/marquee_text.dart';
import 'package:pulse/core/utils/constants/spacing.dart';

class MiniPlayerSongInfo extends StatelessWidget {
  final MusicModel song;

  const MiniPlayerSongInfo({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        MarqueeText(
          text: song.title,
          style: TextStylesManager.bold14,
          duration: const Duration(seconds: 8),
        ),
        verticalSpace2,
        Text(
          song.artist,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStylesManager.regular12.copyWith(
            color: ColorsManager.darkTextSecondary,
          ),
        ),
      ],
    );
  }
}
