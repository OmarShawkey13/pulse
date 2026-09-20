import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pulse/core/errors/either.dart';
import 'package:pulse/core/errors/failures.dart';
import 'package:pulse/core/models/music_model.dart';
import 'package:pulse/core/network/local/database_helper.dart';
import 'package:pulse/features/home/presentation/logic/playlist_songs_cubit.dart';
import 'package:pulse/features/home/presentation/logic/playlist_songs_state.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {}

void main() {
  late MockDatabaseHelper database;
  late PlaylistSongsCubit cubit;

  setUp(() {
    database = MockDatabaseHelper();
    cubit = PlaylistSongsCubit(databaseHelper: database);
  });

  tearDown(() async {
    await cubit.close();
  });

  test('emits loaded songs when the database succeeds', () async {
    final song = MusicModel(
      id: 1,
      path: 'song.mp3',
      title: 'Song',
      artist: 'Artist',
    );
    when(
      () => database.getPlaylistSongs(1),
    ).thenAnswer((_) async => Right<Failure, List<MusicModel>>([song]));

    await cubit.loadSongs(1);

    expect(cubit.state, isA<PlaylistSongsLoaded>());
    expect((cubit.state as PlaylistSongsLoaded).songs, [song]);
  });

  test('emits a translated error key when the database fails', () async {
    when(
      () => database.getPlaylistSongs(1),
    ).thenAnswer(
      (_) async => const Left<Failure, List<MusicModel>>(DatabaseFailure()),
    );

    await cubit.loadSongs(1);

    expect(cubit.state, isA<PlaylistSongsError>());
    expect((cubit.state as PlaylistSongsError).messageKey, 'generic_error');
  });
}
