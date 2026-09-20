import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/models/music_model.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/utils/constants/constants.dart';
import 'package:pulse/core/utils/constants/primary/conditional_builder.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';
import 'package:pulse/features/home/presentation/logic/playlist_songs_cubit.dart';
import 'package:pulse/features/home/presentation/logic/playlist_songs_state.dart';
import 'package:pulse/features/home/presentation/widgets/home_background.dart';
import 'package:pulse/features/home/presentation/widgets/playlists/empty_playlist_songs_view.dart';
import 'package:pulse/features/home/presentation/widgets/playlists/playlist_songs_app_bar.dart';
import 'package:pulse/features/home/presentation/widgets/playlists/playlist_songs_list.dart';

class PlaylistSongsScreen extends StatelessWidget {
  final int playlistId;
  final String playlistName;

  const PlaylistSongsScreen({
    super.key,
    required this.playlistId,
    required this.playlistName,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeCubit.get(context).isDarkMode;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: HomeBackground(
        child: BlocBuilder<PlaylistSongsCubit, PlaylistSongsState>(
          buildWhen: (previous, current) =>
              previous.runtimeType != current.runtimeType,
          builder: (context, state) {
            final songs = state is PlaylistSongsLoaded
                ? state.songs
                : const <MusicModel>[];
            return ConditionalBuilder(
              loadingState: state is PlaylistSongsLoading,
              loadingBuilder: (_) => const Center(
                child: CircularProgressIndicator(color: ColorsManager.primary),
              ),
              errorState: state is PlaylistSongsError,
              errorBuilder: (_) => Center(
                child: Text(
                  appTranslation().get('generic_error'),
                  style: TextStylesManager.regular14.copyWith(
                    color: isDark
                        ? ColorsManager.darkTextSecondary
                        : ColorsManager.lightTextSecondary,
                  ),
                ),
              ),
              successBuilder: (_) => CustomScrollView(
                slivers: [
                  PlaylistSongsAppBar(
                    playlistId: playlistId,
                    playlistName: playlistName,
                    songs: songs,
                    isDark: isDark,
                  ),
                  if (songs.isEmpty)
                    EmptyPlaylistSongsView(isDark: isDark)
                  else
                    PlaylistSongsList(songs: songs),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
