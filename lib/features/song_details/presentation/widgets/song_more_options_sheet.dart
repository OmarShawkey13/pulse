import 'package:flutter/material.dart';
import 'package:pulse/core/models/music_model.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/utils/constants/spacing.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';
import 'package:pulse/features/song_details/presentation/widgets/song_option_tile.dart';

class SongMoreOptionsSheet extends StatelessWidget {
  final MusicModel song;
  final VoidCallback onAddToPlaylist;
  final VoidCallback onShowDetails;
  final VoidCallback onShare;

  const SongMoreOptionsSheet({
    super.key,
    required this.song,
    required this.onAddToPlaylist,
    required this.onShowDetails,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = themeCubit.isDarkMode;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- Header Indicator ---
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: (isDark ? Colors.white24 : Colors.black12),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          verticalSpace16,

          // --- Song Preview Header ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: ColorsManager.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.music_note_rounded,
                    color: ColorsManager.primary,
                  ),
                ),
                horizontalSpace16,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStylesManager.bold16.copyWith(
                          color: isDark
                              ? ColorsManager.white
                              : ColorsManager.black,
                        ),
                      ),
                      Text(
                        song.artist,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStylesManager.regular14.copyWith(
                          color: isDark
                              ? ColorsManager.darkTextSecondary
                              : ColorsManager.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          verticalSpace24,
          const Divider(height: 1),

          // --- Options List ---
          SongOptionTile(
            icon: Icons.playlist_add_rounded,
            label: 'Add to Playlist',
            onTap: onAddToPlaylist,
          ),
          SongOptionTile(
            icon: Icons.info_outline_rounded,
            label: 'Track Details',
            onTap: onShowDetails,
          ),
          SongOptionTile(
            icon: Icons.share_rounded,
            label: 'Share Song',
            onTap: onShare,
          ),
          verticalSpace16,
        ],
      ),
    );
  }
}
