import 'package:flutter/material.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/utils/constants/spacing.dart';

class EmptyPlaylistSongsView extends StatelessWidget {
  final bool isDark;

  const EmptyPlaylistSongsView({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.music_off_rounded,
              size: 64,
              color:
                  (isDark
                          ? ColorsManager.darkTextSecondary
                          : ColorsManager.lightTextSecondary)
                      .withValues(alpha: 0.3),
            ),
            verticalSpace16,
            Text(
              'No songs in this playlist',
              style: TextStylesManager.regular14.copyWith(
                color: isDark
                    ? ColorsManager.darkTextSecondary
                    : ColorsManager.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
