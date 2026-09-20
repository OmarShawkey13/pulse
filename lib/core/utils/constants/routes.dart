import 'package:flutter/material.dart';
import 'package:pulse/features/home/presentation/screen/home_screen.dart';
import 'package:pulse/features/home/presentation/widgets/playlists/playlist_songs_screen.dart';
import 'package:pulse/core/utils/extensions/context_extension.dart';
import 'package:pulse/core/di/injections.dart';
import 'package:pulse/features/home/presentation/logic/playlist_songs_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlaylistSongsRouteArgs {
  final int playlistId;
  final String playlistName;

  const PlaylistSongsRouteArgs({
    required this.playlistId,
    required this.playlistName,
  });
}

class Routes {
  static const String home = "/home";
  static const String playlistSongs = "/playlist-songs";

  static Map<String, WidgetBuilder> get routes => {
    home: (context) => const HomeScreen(),
    playlistSongs: (context) {
      final args = context.getArg<PlaylistSongsRouteArgs>();
      return BlocProvider(
        create: (_) =>
            sl<PlaylistSongsCubit>()..loadSongs(args?.playlistId ?? 0),
        child: PlaylistSongsScreen(
          playlistId: args?.playlistId ?? 0,
          playlistName: args?.playlistName ?? '',
        ),
      );
    },
  };
}
