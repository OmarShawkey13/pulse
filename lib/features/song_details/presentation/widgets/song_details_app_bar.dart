import 'package:flutter/material.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/utils/constants/constants.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';
import 'package:pulse/core/utils/extensions/context_extension.dart';
import 'package:pulse/features/song_details/presentation/widgets/song_more_options_sheet.dart';
import 'package:pulse/features/song_details/presentation/widgets/song_playlist_selector_sheet.dart';
import 'package:pulse/features/song_details/presentation/widgets/song_track_details_sheet.dart';

class SongDetailsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onClose;

  const SongDetailsAppBar({super.key, this.onClose});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeCubit.get(context).isDarkMode;
    return AppBar(
      backgroundColor: ColorsManager.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        appTranslation().get('now_playing'),
        style: TextStylesManager.bold14.copyWith(
          letterSpacing: 2,
          color: isDark
              ? ColorsManager.darkTextSecondary
              : ColorsManager.lightTextSecondary,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 35),
        onPressed: () {
          if (onClose != null) {
            onClose!();
          } else {
            context.pop;
          }
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert_rounded),
          onPressed: () => _showMoreOptions(context),
        ),
      ],
    );
  }

  void _showMoreOptions(BuildContext context) {
    final home = HomeCubit.get(context);
    final isDark = ThemeCubit.get(context).isDarkMode;
    final currentSong = home.songs.firstWhere(
      (s) => s.path == home.currentSongPath,
      orElse: () => home.songs.first,
    );

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: isDark
          ? ColorsManager.darkCard
          : ColorsManager.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SongMoreOptionsSheet(
          song: currentSong,
          onAddToPlaylist: () {
            context.pop;
            _showPlaylistSelector(context);
          },
          onShowDetails: () {
            context.pop;
            _showTrackDetails(context);
          },
          onShare: () {
            context.pop;
          },
        );
      },
    );
  }

  void _showTrackDetails(BuildContext context) {
    final home = HomeCubit.get(context);
    final isDark = ThemeCubit.get(context).isDarkMode;
    final currentSong = home.songs.firstWhere(
      (s) => s.path == home.currentSongPath,
      orElse: () => home.songs.first,
    );

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: isDark
          ? ColorsManager.darkCard
          : ColorsManager.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => SongTrackDetailsSheet(song: currentSong),
    );
  }

  void _showPlaylistSelector(BuildContext context) {
    final home = HomeCubit.get(context);
    final isDark = ThemeCubit.get(context).isDarkMode;
    final currentSong = home.songs.firstWhere(
      (s) => s.path == home.currentSongPath,
      orElse: () => home.songs.first,
    );

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: isDark
          ? ColorsManager.darkCard
          : ColorsManager.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => SongPlaylistSelectorSheet(song: currentSong),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
