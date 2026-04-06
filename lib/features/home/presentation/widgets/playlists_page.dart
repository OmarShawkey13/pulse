import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';
import 'package:pulse/core/utils/cubit/home/home_state.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';
import 'package:pulse/features/home/presentation/widgets/playlists/empty_playlists_view.dart';
import 'package:pulse/features/home/presentation/widgets/playlists/playlists_grid.dart';
import 'package:pulse/features/home/presentation/widgets/playlists/playlists_header.dart';

class PlaylistsPage extends StatelessWidget {
  const PlaylistsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      buildWhen: (previous, current) =>
          current is HomePlaylistsLoadedState ||
          current is HomePlaylistsLoadingState ||
          current is HomePlaylistCreatedState ||
          current is HomePlaylistDeletedState,
      builder: (context, state) {
        final playlists = homeCubit.playlists;
        final isDark = themeCubit.isDarkMode;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PlaylistsHeader(isDark: isDark),
            if (playlists.isEmpty)
              Expanded(child: EmptyPlaylistsView(isDark: isDark))
            else
              Expanded(
                child: PlaylistsGrid(
                  playlists: playlists,
                  isDark: isDark,
                ),
              ),
          ],
        );
      },
    );
  }
}
