import 'package:flutter/material.dart';
import 'package:pulse/core/models/music_model.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/theme/theme.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';
import 'package:pulse/features/home/presentation/widgets/song_search_results.dart';

class SongSearchDelegate extends SearchDelegate {
  final List<MusicModel> songs;

  SongSearchDelegate(this.songs);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = ThemeCubit.get(context).isDarkMode
        ? AppTheme.darkTheme
        : AppTheme.lightTheme;
    return theme.copyWith(
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStylesManager.regular16.copyWith(
          color: ColorsManager.grey,
        ),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear_rounded),
          onPressed: () {
            query = '';
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SongSearchResults(songs: songs, query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SongSearchResults(songs: songs, query: query);
  }
}
