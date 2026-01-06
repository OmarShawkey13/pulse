import 'package:audio_service/audio_service.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart' as audio;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/di/injections.dart';
import 'package:pulse/core/models/song_model.dart';
import 'package:pulse/core/network/local/cache_helper.dart';
import 'package:pulse/core/network/local/database_helper.dart';
import 'package:pulse/core/network/service/palette_service.dart';
import 'package:pulse/core/network/service/pulse_audio_handler.dart';
import 'package:pulse/core/utils/cubit/home_state.dart';
import 'package:pulse/main.dart';

HomeCubit get homeCubit => HomeCubit.get(navigatorKey.currentContext!);

class HomeCubit extends Cubit<HomeStates> {
  final PulseAudioHandler _audioHandler = sl<PulseAudioHandler>();
  final audio.OnAudioQuery _audioQuery = audio.OnAudioQuery();

  PulseAudioHandler get audioHandler => _audioHandler;

  static HomeCubit get(BuildContext context) => BlocProvider.of(context);

  HomeCubit() : super(HomeInitialState());

  // Variables
  bool _isDarkMode = false;
  List<String> _queue = [];
  List<SongModel> songs = [];
  List<SongModel> recentSongs = [];
  List<SongModel> favorites = [];
  int _currentIndex = -1;
  int _selectedTabIndex = 0;
  Color? waveColor;

  // Getters
  bool get isDarkMode => _isDarkMode;

  bool get hasNext => _currentIndex < _queue.length - 1;

  bool get hasPrevious => _currentIndex > 0;

  int get selectedTabIndex => _selectedTabIndex;

  String? get currentSongPath =>
      (_currentIndex >= 0 && _currentIndex < _queue.length)
      ? _queue[_currentIndex]
      : null;

  Stream<Duration> get positionStream => AudioService.position;

  Stream<PlaybackState> get playbackStateStream => _audioHandler.playbackState;

  // Theme
  void changeTheme({bool? fromShared}) {
    _isDarkMode = fromShared ?? !_isDarkMode;
    CacheHelper.saveData(key: 'isDark', value: _isDarkMode);
    emit(HomeChangeThemeState());
  }

  // Tabs
  void changeTab(int index) {
    _selectedTabIndex = index;
    emit(HomeTabChangedState());
  }

  // Initialization
  void initializeAudioHandler() {
    _audioHandler.onSkipToNext = playNext;
    _audioHandler.onSkipToPrevious = playPrevious;
    _audioHandler.onSongFinished = _onSongFinished;

    _audioHandler.playbackState.listen((state) {
      if (state.processingState == AudioProcessingState.idle ||
          state.processingState == AudioProcessingState.ready) {
        _saveLastPlayedSong();
      }
    });

    loadFavorites();
  }

  // Audio Controls
  Future<void> seek(Duration position) => _audioHandler.seek(position);

  Future<void> playSong(String path, {List<String>? queue}) async {
    if (queue != null) setQueue(queue);

    final index = _queue.indexOf(path);
    if (index == -1) return;

    _currentIndex = index;

    _resetWaveColor();
    emit(HomePlayerPlayState(path));

    loadWavePalette();

    final song = _getSongDetails(path);

    // Only set song if it's different to avoid reloading
    if (_audioHandler.mediaItem.value?.id != path) {
      await _audioHandler.setSong(
        path,
        title: song.title,
        artist: song.artist,
        id: song.id,
      );
    }

    await _audioHandler.play();
  }

  Future<void> _onSongFinished() async {
    final repeatMode = _audioHandler.playbackState.value.repeatMode;

    if (repeatMode == AudioServiceRepeatMode.one) {
      await seek(Duration.zero);
      await _audioHandler.play();
      return;
    }

    await playNext();
  }

  Future<void> playNext() async {
    final isRepeatAll =
        _audioHandler.playbackState.value.repeatMode ==
        AudioServiceRepeatMode.all;

    if (!hasNext) {
      if (!isRepeatAll || _queue.isEmpty) return;
      _currentIndex = -1; // Prepare to wrap around
    }

    _currentIndex++;
    await _changeSongAtIndex();
    emit(HomePlayerNextState(_queue[_currentIndex]));
  }

  Future<void> playPrevious() async {
    final isRepeatAll =
        _audioHandler.playbackState.value.repeatMode ==
        AudioServiceRepeatMode.all;

    if (!hasPrevious) {
      if (!isRepeatAll || _queue.isEmpty) return;
      _currentIndex = _queue.length; // Prepare to wrap around
    }

    _currentIndex--;
    await _changeSongAtIndex();
    emit(HomePlayerPreviousState(_queue[_currentIndex]));
  }

  Future<void> pauseSong() async {
    await _audioHandler.pause();
    emit(HomePlayerPauseState());
  }

  Future<void> stopSong() async {
    await _audioHandler.stop();
    emit(HomePlayerStopState());
  }

  Future<void> cycleRepeatMode() async {
    final currentMode = _audioHandler.playbackState.value.repeatMode;
    final nextMode = switch (currentMode) {
      AudioServiceRepeatMode.none => AudioServiceRepeatMode.all,
      AudioServiceRepeatMode.all => AudioServiceRepeatMode.one,
      AudioServiceRepeatMode.one => AudioServiceRepeatMode.none,
      _ => AudioServiceRepeatMode.none,
    };
    await _audioHandler.setRepeatMode(nextMode);
  }

  // Helper for next/previous navigation
  Future<void> _changeSongAtIndex() async {
    _resetWaveColor();
    loadWavePalette();
    await _playCurrentIndex();
  }

  Future<void> _playCurrentIndex() async {
    if (_currentIndex < 0 || _currentIndex >= _queue.length) return;

    final path = _queue[_currentIndex];
    final song = _getSongDetails(path);
    await _audioHandler.setSong(
      path,
      title: song.title,
      artist: song.artist,
      id: song.id,
    );
    await _audioHandler.play();
  }

  // Data Loading
  Future<void> loadSongs({bool retry = false}) async {
    emit(HomeLoadSongsLoadingState());

    try {
      final hasPermission = await _audioQuery.checkAndRequest(
        retryRequest: retry,
      );

      if (!hasPermission) {
        emit(HomeLoadSongsErrorState('Permission denied'));
        return;
      }

      final result = await _audioQuery.querySongs(
        sortType: audio.SongSortType.TITLE,
        orderType: audio.OrderType.ASC_OR_SMALLER,
        uriType: audio.UriType.EXTERNAL,
        ignoreCase: true,
      );

      // Filter invalid or system sounds
      final filteredList = result.where((e) {
        final isSystemSound =
            (e.isAlarm ?? false) ||
            (e.isRingtone ?? false) ||
            (e.isNotification ?? false);
        return e.data.isNotEmpty && !isSystemSound && (e.isMusic ?? false);
      }).toList();

      SongModel mapToSongModel(audio.SongModel e) => SongModel(
        id: e.id,
        path: e.data,
        title: e.title,
        artist: (e.artist == null || e.artist == '<unknown>')
            ? 'Unknown'
            : e.artist!,
      );

      songs = filteredList.map(mapToSongModel).toList();

      // Populate recentSongs (sorted by date added)
      final recentList = List<audio.SongModel>.from(filteredList)
        ..sort((a, b) => (b.dateAdded ?? 0).compareTo(a.dateAdded ?? 0));

      recentSongs = recentList.map(mapToSongModel).toList();

      setQueue(songs.map((e) => e.path).toList());

      await _restoreLastPlayedSong();
      await loadFavorites();

      emit(HomeLoadSongsSuccessState(songs));
    } catch (e) {
      emit(HomeLoadSongsErrorState(e.toString()));
    }
  }

  // Favorites
  Future<void> loadFavorites() async {
    favorites = await DatabaseHelper.instance.getFavorites();
    emit(HomeFavoritesLoadedState(favorites));
  }

  Future<void> toggleFavorite(SongModel song) async {
    final isFav = isSongFavorite(song.id);
    if (isFav) {
      await DatabaseHelper.instance.removeFavorite(song.id);
    } else {
      await DatabaseHelper.instance.addFavorite(song);
    }
    await loadFavorites();
    emit(HomeFavoriteToggledState(!isFav));
  }

  bool isSongFavorite(int id) {
    return favorites.any((element) => element.id == id);
  }

  // Helpers
  void setQueue(List<String> paths, {int startIndex = 0}) {
    _queue = paths;
    _currentIndex = startIndex;
  }

  SongModel _getSongDetails(String path) {
    return songs.firstWhere(
      (e) => e.path == path,
      orElse: () =>
          SongModel(id: 0, path: path, title: 'Unknown', artist: 'Unknown'),
    );
  }

  void _resetWaveColor() {
    if (waveColor != null) {
      waveColor = null;
      emit(HomeWaveColorUpdated());
    }
  }

  Future<void> _saveLastPlayedSong() async {
    if (currentSongPath != null) {
      await CacheHelper.saveData(key: 'last_song_path', value: currentSongPath);
      await CacheHelper.saveData(
        key: 'last_song_position',
        value: _audioHandler.playbackState.value.position.inSeconds,
      );
      // Save the current queue to maintain context
      await CacheHelper.saveData(key: 'last_queue', value: _queue);

      // Save repeat mode
      await CacheHelper.saveData(
        key: 'repeat_mode',
        value: _audioHandler.playbackState.value.repeatMode.index,
      );
    }
  }

  Future<void> _restoreLastPlayedSong() async {
    final lastPath = CacheHelper.getData(key: 'last_song_path');
    final lastPositionSeconds = CacheHelper.getData(key: 'last_song_position');
    final lastQueue = CacheHelper.getData(key: 'last_queue');
    final lastRepeatMode = CacheHelper.getData(key: 'repeat_mode');

    // Restore Queue if exists
    if (lastQueue != null && lastQueue is List) {
      final storedQueue = lastQueue.map((e) => e.toString()).toList();
      if (storedQueue.isNotEmpty) {
        _queue = storedQueue;
      }
    }

    // Restore Repeat Mode
    if (lastRepeatMode is int &&
        lastRepeatMode >= 0 &&
        lastRepeatMode < AudioServiceRepeatMode.values.length) {
      await _audioHandler.setRepeatMode(
        AudioServiceRepeatMode.values[lastRepeatMode],
      );
    }

    if (lastPath is! String) return;

    final index = _queue.indexOf(lastPath);
    if (index == -1) return;

    _currentIndex = index;
    final song = _getSongDetails(lastPath);

    await _audioHandler.setSong(
      lastPath,
      title: song.title,
      artist: song.artist,
      id: song.id,
    );

    // Don't auto-play on restore, just prepare
    await loadWavePalette();

    if (lastPositionSeconds is int) {
      await _audioHandler.seek(Duration(seconds: lastPositionSeconds));
    }

    emit(HomePlayerPauseState());
  }

  Future<void> loadWavePalette() async {
    if (currentSongPath == null) return;

    try {
      final song = songs.firstWhere(
        (e) => e.path == currentSongPath,
        orElse: () => songs.first,
      );

      final bytes = await _audioQuery.queryArtwork(
        song.id,
        audio.ArtworkType.AUDIO,
        quality: 100,
      );

      if (bytes == null) {
        _resetWaveColor();
        return;
      }

      waveColor = await PaletteService.extractDominantColorFromBytes(bytes);
      emit(HomeWaveColorUpdated());
    } catch (e) {
      debugPrint('Error loading palette: $e');
      _resetWaveColor();
    }
  }
}
