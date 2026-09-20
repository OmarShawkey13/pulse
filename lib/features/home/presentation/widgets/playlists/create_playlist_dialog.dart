import 'package:flutter/material.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/utils/constants/constants.dart';
import 'package:pulse/core/utils/extensions/context_extension.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';

void showCreatePlaylistDialog(BuildContext context) {
  final controller = TextEditingController();
  final theme = ThemeCubit.get(context);
  final home = HomeCubit.get(context);
  final isDark = theme.isDarkMode;

  showDialog<Object>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: isDark
          ? ColorsManager.darkCard
          : ColorsManager.lightSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(
        appTranslation().get('new_playlist'),
        style: TextStylesManager.bold20.copyWith(
          color: isDark
              ? ColorsManager.darkTextPrimary
              : ColorsManager.lightTextPrimary,
        ),
      ),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(
          hintText: appTranslation().get('playlist_name_hint'),
          filled: true,
          fillColor: (isDark ? ColorsManager.white : ColorsManager.black)
              .withValues(
                alpha: 0.05,
              ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop,
          child: Text(appTranslation().get('cancel')),
        ),
        ElevatedButton(
          onPressed: () {
            if (controller.text.trim().isNotEmpty) {
              home.createPlaylist(controller.text.trim());
              context.pop;
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorsManager.primary,
            foregroundColor: ColorsManager.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(appTranslation().get('create')),
        ),
      ],
    ),
  );
}
