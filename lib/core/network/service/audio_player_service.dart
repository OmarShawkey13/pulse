import 'package:just_audio/just_audio.dart';
import 'package:pulse/core/errors/either.dart';
import 'package:pulse/core/errors/failures.dart';

class AudioPlayerService {
  final AudioPlayer _player;

  AudioPlayerService({AudioPlayer? player}) : _player = player ?? AudioPlayer();

  bool get isPlaying => _player.playing;

  Future<Either<Failure, void>> play(String path) async {
    try {
      await _player.setFilePath(path);
      await _player.play();
      return const Right(null);
    } catch (_) {
      return const Left(AudioFailure());
    }
  }

  Future<Either<Failure, void>> pause() async {
    try {
      await _player.pause();
      return const Right(null);
    } catch (_) {
      return const Left(AudioFailure());
    }
  }

  Future<Either<Failure, void>> stop() async {
    try {
      await _player.stop();
      return const Right(null);
    } catch (_) {
      return const Left(AudioFailure());
    }
  }

  Future<Either<Failure, void>> dispose() async {
    try {
      await _player.dispose();
      return const Right(null);
    } catch (_) {
      return const Left(AudioFailure());
    }
  }
}
