import 'package:flutter/material.dart';
import 'package:pulse/core/models/music_model.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/utils/constants/spacing.dart';
import 'package:pulse/core/utils/constants/constants.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';
import 'package:pulse/features/song_details/presentation/widgets/song_detail_item.dart';

class SongTrackDetailsSheet extends StatelessWidget {
  final MusicModel song;

  const SongTrackDetailsSheet({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeCubit.get(context).isDarkMode;

    // Format duration: handle null/zero
    String durationText = appTranslation().get('unknown');
    if (song.duration != null && song.duration! > 0) {
      final duration = Duration(milliseconds: song.duration!);
      final minutes = duration.inMinutes;
      final seconds = duration.inSeconds % 60;
      durationText =
          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }

    // Format size: handle null/zero
    String sizeText = appTranslation().get('unknown');
    if (song.size != null && song.size! > 0) {
      final sizeInMb = song.size! / (1024 * 1024);
      sizeText = '${sizeInMb.toStringAsFixed(2)} MB';
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? ColorsManager.white24 : ColorsManager.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            verticalSpace24,
            Text(
              appTranslation().get('track_details'),
              style: TextStylesManager.bold20.copyWith(
                color: isDark ? ColorsManager.white : ColorsManager.black,
              ),
            ),
            verticalSpace24,
            SongDetailItem(
              label: appTranslation().get('title'),
              value: song.title,
              isDark: isDark,
            ),
            SongDetailItem(
              label: appTranslation().get('artist'),
              value: song.artist,
              isDark: isDark,
            ),
            SongDetailItem(
              label: appTranslation().get('album'),
              value: (song.album == null || song.album == '<unknown>')
                  ? appTranslation().get('unknown')
                  : song.album!,
              isDark: isDark,
            ),
            SongDetailItem(
              label: appTranslation().get('duration'),
              value: durationText,
              isDark: isDark,
            ),
            SongDetailItem(
              label: appTranslation().get('size'),
              value: sizeText,
              isDark: isDark,
            ),
            SongDetailItem(
              label: appTranslation().get('path'),
              value: song.path,
              isDark: isDark,
              isPath: true,
            ),
            verticalSpace16,
          ],
        ),
      ),
    );
  }
}
