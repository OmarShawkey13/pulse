import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';
import 'package:pulse/core/utils/cubit/home/home_state.dart';
import 'package:pulse/features/home/presentation/widgets/favorite_songs_list.dart';
import 'package:pulse/features/home/presentation/widgets/home_content.dart';
import 'package:pulse/features/home/presentation/widgets/recent_songs_list.dart';
import 'package:pulse/features/home/presentation/widgets/playlists_page.dart';

class HomePagesView extends StatelessWidget {
  final PageController controller;
  final void Function(int) onPageChanged;

  const HomePagesView({
    super.key,
    required this.controller,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocSelector<HomeCubit, HomeStates, bool>(
        selector: (state) => homeCubit.currentSongPath != null,
        builder: (context, hasSong) {
          return AnimatedPadding(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.only(
              bottom: hasSong
                  ? 85
                  : 0, // Slightly more padding for better spacing
            ),
            child: PageView(
              controller: controller,
              onPageChanged: onPageChanged,
              children: const [
                HomeContent(),
                RecentSongsList(),
                FavoriteSongsList(),
                PlaylistsPage(),
              ],
            ),
          );
        },
      ),
    );
  }
}
