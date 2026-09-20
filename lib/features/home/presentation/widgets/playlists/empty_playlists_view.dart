import 'package:flutter/material.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/utils/constants/spacing.dart';
import 'package:pulse/core/utils/constants/constants.dart';

class EmptyPlaylistsView extends StatelessWidget {
  final bool isDark;

  const EmptyPlaylistsView({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.library_music_rounded,
            size: 80,
            color:
                (isDark
                        ? ColorsManager.darkTextSecondary
                        : ColorsManager.lightTextSecondary)
                    .withValues(alpha: 0.2),
          ),
          verticalSpace16,
          Text(
            appTranslation().get('no_playlists_yet'),
            style: TextStylesManager.regular14.copyWith(
              color: isDark
                  ? ColorsManager.darkTextSecondary
                  : ColorsManager.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
