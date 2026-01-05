import 'package:audio_service/audio_service.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart' as audio;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/di/injections.dart';
import 'package:pulse/core/models/song_model.dart';
import 'package:pulse/core/network/local/cache_helper.dart';
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
  int _currentIndex = -1;

  // Getters
  bool get isDarkMode => _isDarkMode;

  bool get hasNext => _currentIndex < _queue.length - 1;

  bool get hasPrevious => _currentIndex > 0;

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

  // Initialization
  void initializeAudioHandler() {
    _audioHandler.onSkipToNext = playNext;
    _audioHandler.onSkipToPrevious = playPrevious;
    _audioHandler.playbackState.listen((state) {
      if (state.processingState == AudioProcessingState.idle ||
          state.processingState == AudioProcessingState.ready) {
        _saveLastPlayedSong();
      }
    });
  }

  // Audio Controls
  Future<void> seek(Duration position) => _audioHandler.seek(position);

  Future<void> playSong(String path) async {
    final index = _queue.indexOf(path);
    if (index == -1) return;

    _currentIndex = index;

    // Reset color to avoid showing previous song's color
    waveColor = null;
    emit(HomeWaveColorUpdated());

    emit(HomePlayerPlayState(path));

    // Load palette
    loadWavePalette();

    final song = _getSongDetails(path);

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

  Future<void> playNext() async {
    if (!hasNext) return;
    _currentIndex++;

    waveColor = null;
    emit(HomeWaveColorUpdated());

    loadWavePalette();

    await _playCurrentIndex();
    emit(HomePlayerNextState(_queue[_currentIndex]));
  }

  Future<void> playPrevious() async {
    if (!hasPrevious) return;
    _currentIndex--;

    waveColor = null;
    emit(HomeWaveColorUpdated());

    loadWavePalette();

    await _playCurrentIndex();
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

  Future<void> _playCurrentIndex() async {
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

      songs = result
          .where((e) => e.data.isNotEmpty)
          .map(
            (e) => SongModel(
              id: e.id,
              path: e.data,
              title: e.title,
              artist: e.artist == null || e.artist == '<unknown>'
                  ? 'Unknown'
                  : e.artist!,
            ),
          )
          .toList();

      setQueue(songs.map((e) => e.path).toList());
      await _restoreLastPlayedSong();

      emit(HomeLoadSongsSuccessState(songs));
    } catch (e) {
      emit(HomeLoadSongsErrorState(e.toString()));
    }
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

  Future<void> _saveLastPlayedSong() async {
    if (currentSongPath != null) {
      await CacheHelper.saveData(key: 'last_song_path', value: currentSongPath);
      await CacheHelper.saveData(
        key: 'last_song_position',
        value: _audioHandler.playbackState.value.position.inSeconds,
      );
    }
  }

  Future<void> _restoreLastPlayedSong() async {
    final lastPath = CacheHelper.getData(key: 'last_song_path');
    final lastPositionSeconds = CacheHelper.getData(key: 'last_song_position');

    if (lastPath is String) {
      final index = _queue.indexOf(lastPath);
      if (index != -1) {
        _currentIndex = index;
        final song = _getSongDetails(lastPath);

        await _audioHandler.setSong(
          lastPath,
          title: song.title,
          artist: song.artist,
          id: song.id,
        );

        await loadWavePalette();

        if (lastPositionSeconds is int) {
          await _audioHandler.seek(Duration(seconds: lastPositionSeconds));
        }
        emit(HomePlayerPauseState());
      }
    }
  }

  Color? waveColor;

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
        if (waveColor != null) {
          waveColor = null;
          emit(HomeWaveColorUpdated());
        }
        return;
      }

      final color = await PaletteService.extractDominantColorFromBytes(bytes);

      waveColor = color;
      emit(HomeWaveColorUpdated());
    } catch (e) {
      debugPrint('Error loading palette: $e');
      waveColor = null;
      emit(HomeWaveColorUpdated());
    }
  }
}
