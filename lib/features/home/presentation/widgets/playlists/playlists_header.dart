import 'package:flutter/material.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/features/home/presentation/widgets/playlists/create_playlist_dialog.dart';

class PlaylistsHeader extends StatelessWidget {
  final bool isDark;

  const PlaylistsHeader({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Your Library',
            style: TextStylesManager.bold24.copyWith(
              color: isDark
                  ? ColorsManager.darkTextPrimary
                  : ColorsManager.lightTextPrimary,
            ),
          ),
          IconButton(
            onPressed: () => showCreatePlaylistDialog(context),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ColorsManager.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_rounded,
                color: ColorsManager.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
