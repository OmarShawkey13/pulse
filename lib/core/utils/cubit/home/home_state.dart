import 'package:pulse/core/models/music_model.dart';

abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

//play states
class HomePlayerPlayState extends HomeStates {
  final String path;
  HomePlayerPlayState(this.path);
}

class HomePlayerPauseState extends HomeStates {}

class HomePlayerStopState extends HomeStates {}

//Next / Previous
class HomePlayerNextState extends HomeStates {
  final String path;
  HomePlayerNextState(this.path);
}

class HomePlayerPreviousState extends HomeStates {
  final String path;
  HomePlayerPreviousState(this.path);
}

//get Song
class HomeLoadSongsLoadingState extends HomeStates {}

class HomeLoadSongsSuccessState extends HomeStates {
  final List<MusicModel> songs;
  HomeLoadSongsSuccessState(this.songs);
}

class HomeLoadSongsErrorState extends HomeStates {
  final String error;
  HomeLoadSongsErrorState(this.error);
}

//palette
class HomeWaveColorUpdated extends HomeStates {}

// Tab Switch
class HomeTabChangedState extends HomeStates {}

//shuffle
class HomeShuffleChanged extends HomeStates {
  final bool isEnabled;

  HomeShuffleChanged(this.isEnabled);
}

// Favorites
class HomeFavoriteToggledState extends HomeStates {
  final bool isFavorite;
  HomeFavoriteToggledState(this.isFavorite);
}

class HomeFavoritesLoadedState extends HomeStates {
  final List<MusicModel> favorites;
  HomeFavoritesLoadedState(this.favorites);
}

// Playlists
class HomePlaylistsLoadingState extends HomeStates {}

class HomePlaylistsLoadedState extends HomeStates {
  final List<Map<String, dynamic>> playlists;
  HomePlaylistsLoadedState(this.playlists);
}

class HomePlaylistSongsLoadedState extends HomeStates {
  final List<MusicModel> songs;
  HomePlaylistSongsLoadedState(this.songs);
}

class HomePlaylistCreatedState extends HomeStates {}

class HomePlaylistDeletedState extends HomeStates {}

class HomeSongAddedToPlaylistState extends HomeStates {}
