import 'package:flutter/material.dart';
import 'package:pulse/core/models/music_model.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/utils/constants/spacing.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';
import 'package:pulse/features/song_details/presentation/widgets/song_detail_item.dart';

class SongTrackDetailsSheet extends StatelessWidget {
  final MusicModel song;

  const SongTrackDetailsSheet({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    final isDark = themeCubit.isDarkMode;

    // Format duration: handle null/zero
    String durationText = 'Unknown';
    if (song.duration != null && song.duration! > 0) {
      final duration = Duration(milliseconds: song.duration!);
      final minutes = duration.inMinutes;
      final seconds = duration.inSeconds % 60;
      durationText =
          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }

    // Format size: handle null/zero
    String sizeText = 'Unknown';
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
                  color: (isDark ? Colors.white24 : Colors.black12),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            verticalSpace24,
            Text(
              'Track Details',
              style: TextStylesManager.bold20.copyWith(
                color: isDark ? ColorsManager.white : ColorsManager.black,
              ),
            ),
            verticalSpace24,
            SongDetailItem(label: 'Title', value: song.title, isDark: isDark),
            SongDetailItem(label: 'Artist', value: song.artist, isDark: isDark),
            SongDetailItem(
              label: 'Album',
              value: (song.album == null || song.album == '<unknown>')
                  ? 'Unknown'
                  : song.album!,
              isDark: isDark,
            ),
            SongDetailItem(
              label: 'Duration',
              value: durationText,
              isDark: isDark,
            ),
            SongDetailItem(
              label: 'Size',
              value: sizeText,
              isDark: isDark,
            ),
            SongDetailItem(
              label: 'Path',
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
