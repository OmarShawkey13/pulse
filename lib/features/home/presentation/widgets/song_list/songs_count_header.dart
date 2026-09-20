import 'package:flutter/material.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/utils/constants/constants.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';

class SongsCountHeader extends StatelessWidget {
  final int count;

  const SongsCountHeader({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeCubit.get(context).isDarkMode;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        appTranslation().get('song_count_title', params: {'count': count}),
        style: TextStylesManager.bold16.copyWith(
          color:
              (isDark
                      ? ColorsManager.darkTextPrimary
                      : ColorsManager.lightTextPrimary)
                  .withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
