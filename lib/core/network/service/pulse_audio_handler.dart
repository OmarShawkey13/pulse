import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class PulseAudioHandler extends BaseAudioHandler {
  final AudioPlayer _player = AudioPlayer();

  // Callbacks for external logic (e.g., Cubit)
  Future<void> Function()? onSkipToNext;
  Future<void> Function()? onSkipToPrevious;

  PulseAudioHandler() {
    _player.playbackEventStream.listen(_broadcastState);
    _player.durationStream.listen((duration) {
      if (duration != null) {
        final currentMediaItem = mediaItem.value;
        if (currentMediaItem != null) {
          mediaItem.add(currentMediaItem.copyWith(duration: duration));
        }
      }
    });

    // Listen for playback completion
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        skipToNext();
      }
    });
  }

  void _broadcastState(PlaybackEvent event) {
    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          _player.playing ? MediaControl.pause : MediaControl.play,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.skipToNext,
          MediaAction.skipToPrevious,
        },
        androidCompactActionIndices: const [0, 1, 2],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        playing: _player.playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
      ),
    );
  }

  // ▶️ PLAY
  @override
  Future<void> play() => _player.play();

  // ⏸ PAUSE
  @override
  Future<void> pause() => _player.pause();

  // ⏹ STOP
  @override
  Future<void> stop() async {
    await _player.stop();
    await super.stop();
  }

  // ⏭ NEXT
  @override
  Future<void> skipToNext() async {
    if (onSkipToNext != null) {
      await onSkipToNext!();
    }
  }

  // ⏮ PREVIOUS
  @override
  Future<void> skipToPrevious() async {
    if (onSkipToPrevious != null) {
      await onSkipToPrevious!();
    }
  }

  // ⏩ SEEK
  @override
  Future<void> seek(Duration position) => _player.seek(position);

  Future<void> setSong(
    String path, {
    required String title,
    required String artist,
    required int id,
  }) async {
    mediaItem.add(
      MediaItem(
        id: path,
        title: title,
        artist: artist,
        // Android content URI for artwork
        artUri: Uri.parse('content://media/external/audio/media/$id/albumart'),
        duration: null, // Reset duration while loading
      ),
    );
    await _player.setFilePath(path);
    // Duration will be updated by the listener
  }

  void dispose() {
    _player.dispose();
  }
}
