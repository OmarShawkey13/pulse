import 'package:pulse/core/models/music_model.dart';

sealed class PlaylistSongsState {
  const PlaylistSongsState();
}

class PlaylistSongsInitial extends PlaylistSongsState {
  const PlaylistSongsInitial();
}

class PlaylistSongsLoading extends PlaylistSongsState {
  const PlaylistSongsLoading();
}

class PlaylistSongsLoaded extends PlaylistSongsState {
  final List<MusicModel> songs;

  const PlaylistSongsLoaded(this.songs);
}

class PlaylistSongsError extends PlaylistSongsState {
  final String messageKey;

  const PlaylistSongsError(this.messageKey);
}
