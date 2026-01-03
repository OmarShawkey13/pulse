import 'package:pulse/core/models/song_model.dart';

abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class HomeChangeThemeState extends HomeStates {}

class HomeLanguageUpdatedState extends HomeStates {}

class HomeLanguageLoadingState extends HomeStates {}

class HomeLanguageLoadedState extends HomeStates {}

class HomeLanguageErrorState extends HomeStates {
  final String error;

  HomeLanguageErrorState(this.error);
}

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
  final List<SongModel> songs;
  HomeLoadSongsSuccessState(this.songs);
}

class HomeLoadSongsErrorState extends HomeStates {
  final String error;
  HomeLoadSongsErrorState(this.error);
}

//palette
class HomeWaveColorUpdated extends HomeStates {}
