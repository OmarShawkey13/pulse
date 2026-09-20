import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/errors/either.dart';
import 'package:pulse/core/errors/failures.dart';
import 'package:pulse/core/models/music_model.dart';
import 'package:pulse/core/network/local/database_helper.dart';
import 'package:pulse/features/home/presentation/logic/playlist_songs_state.dart';

class PlaylistSongsCubit extends Cubit<PlaylistSongsState> {
  final DatabaseHelper _databaseHelper;

  PlaylistSongsCubit({DatabaseHelper? databaseHelper})
    : _databaseHelper = databaseHelper ?? DatabaseHelper.instance,
      super(const PlaylistSongsInitial());

  static PlaylistSongsCubit get(BuildContext context) =>
      BlocProvider.of(context);

  Future<Either<Failure, List<MusicModel>>> loadSongs(int playlistId) async {
    emit(const PlaylistSongsLoading());
    try {
      final result = await _databaseHelper.getPlaylistSongs(playlistId);
      return await result.fold(
        (failure) {
          emit(PlaylistSongsError(failure.messageKey));
          return Left(failure);
        },
        (songs) {
          emit(PlaylistSongsLoaded(songs));
          return Right(songs);
        },
      );
    } catch (_) {
      emit(const PlaylistSongsError('generic_error'));
      return const Left(DatabaseFailure());
    }
  }
}
