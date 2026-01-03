import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  final AudioPlayer _player;

  AudioPlayerService({AudioPlayer? player}) : _player = player ?? AudioPlayer();

  bool get isPlaying => _player.playing;

  Future<void> play(String path) async {
    await _player.setFilePath(path);
    await _player.play();
  }

  Future<void> pause() async => _player.pause();

  Future<void> stop() async => _player.stop();

  void dispose() => _player.dispose();
}
