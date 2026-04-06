import 'package:flutter/material.dart';
import 'package:pulse/core/models/music_model.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';
import 'package:pulse/features/home/presentation/widgets/home_background.dart';
import 'package:pulse/features/home/presentation/widgets/playlists/empty_playlist_songs_view.dart';
import 'package:pulse/features/home/presentation/widgets/playlists/playlist_songs_app_bar.dart';
import 'package:pulse/features/home/presentation/widgets/playlists/playlist_songs_list.dart';

class PlaylistSongsScreen extends StatefulWidget {
  final int playlistId;
  final String playlistName;

  const PlaylistSongsScreen({
    super.key,
    required this.playlistId,
    required this.playlistName,
  });

  @override
  State<PlaylistSongsScreen> createState() => _PlaylistSongsScreenState();
}

class _PlaylistSongsScreenState extends State<PlaylistSongsScreen> {
  List<MusicModel> _songs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    final songs = await homeCubit.getPlaylistSongs(widget.playlistId);
    if (mounted) {
      setState(() {
        _songs = songs;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeCubit.isDarkMode;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: HomeBackground(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  PlaylistSongsAppBar(
                    playlistId: widget.playlistId,
                    playlistName: widget.playlistName,
                    songs: _songs,
                    isDark: isDark,
                  ),
                  if (_songs.isEmpty)
                    EmptyPlaylistSongsView(isDark: isDark)
                  else
                    PlaylistSongsList(songs: _songs),
                ],
              ),
      ),
    );
  }
}
