import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/utils/constants/constants.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';
import 'package:pulse/core/utils/cubit/theme/theme_state.dart';

import 'package:pulse/features/home/presentation/widgets/song_search_delegate.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (_, state) =>
          state is ThemeChangeThemeState || state is ThemeLanguageUpdatedState,
      builder: (context, state) {
        final theme = ThemeCubit.get(context);
        final home = HomeCubit.get(context);
        final isDark = theme.isDarkMode;
        return AppBar(
          title: Text(
            appTranslation().get('app_title'),
            style: TextStylesManager.bold20.copyWith(
              color: isDark
                  ? ColorsManager.darkTextPrimary
                  : ColorsManager.lightTextPrimary,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: SongSearchDelegate(home.songs),
                );
              },
              icon: Icon(
                Icons.search_rounded,
                color: isDark
                    ? ColorsManager.darkTextPrimary
                    : ColorsManager.lightTextPrimary,
              ),
            ),
            IconButton(
              onPressed: () => theme.changeTheme(),
              icon: Icon(
                isDark ? Icons.wb_sunny : Icons.nightlight_round,
                color: isDark
                    ? ColorsManager.warning
                    : ColorsManager.lightTextPrimary,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
