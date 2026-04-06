import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pulse/core/models/music_model.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/utils/constants/spacing.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';
import 'package:pulse/features/song_details/presentation/widgets/song_controls.dart';
import 'package:pulse/features/song_details/presentation/widgets/song_favorite_button.dart';
import 'package:pulse/features/song_details/presentation/widgets/song_seek_bar.dart';
import 'package:pulse/features/song_details/presentation/widgets/song_title_section.dart';

class SongDetailsGlassCard extends StatelessWidget {
  final MusicModel song;

  const SongDetailsGlassCard({
    super.key,
    required this.song,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            decoration: BoxDecoration(
              color:
                  (isDark
                          ? ColorsManager.darkSurface
                          : ColorsManager.lightSurface)
                      .withValues(alpha: isDark ? 0.05 : 0.3),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                  blurRadius: 40,
                  offset: const Offset(0, 10),
                ),
              ],
              border: Border.all(
                color: ColorsManager.lightSurface.withValues(
                  alpha: isDark ? 0.03 : 0.15,
                ),
                width: 0.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(child: SongTitleSection(song: song)),
                    horizontalSpace12,
                    SongFavoriteButton(
                      isFav: homeCubit.isSongFavorite(song.id),
                      isDark: isDark,
                      onPressed: () => homeCubit.toggleFavorite(song),
                    ),
                  ],
                ),
                verticalSpace24,
                const SongSeekBar(),
                verticalSpace16,
                SongControls(songPath: song.path),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
