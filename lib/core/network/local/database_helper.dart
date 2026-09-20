import 'package:path/path.dart';
import 'package:pulse/core/errors/either.dart';
import 'package:pulse/core/errors/failures.dart';
import 'package:pulse/core/models/music_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('pulse_favorites.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1, // Increment version for schema change
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY,
        path TEXT NOT NULL,
        title TEXT NOT NULL,
        artist TEXT NOT NULL,
        album TEXT,
        duration INTEGER,
        size INTEGER,
        timestamp INTEGER DEFAULT 0
      )
    ''');
    await _createPlaylistsTable(db);
  }

  Future<void> _createPlaylistsTable(Database db) async {
    await db.execute('''
      CREATE TABLE playlists (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        createdAt INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE playlist_songs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        playlistId INTEGER NOT NULL,
        songId INTEGER NOT NULL,
        songPath TEXT NOT NULL,
        songTitle TEXT NOT NULL,
        songArtist TEXT NOT NULL,
        songAlbum TEXT,
        songDuration INTEGER,
        songSize INTEGER,
        FOREIGN KEY (playlistId) REFERENCES playlists (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<Either<Failure, void>> addFavorite(MusicModel song) async {
    try {
      final db = await instance.database;
      await db.insert(
        'favorites',
        {
          ...song.toMap(),
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return const Right(null);
    } catch (_) {
      return const Left(DatabaseFailure());
    }
  }

  Future<Either<Failure, void>> removeFavorite(int id) async {
    try {
      final db = await instance.database;
      await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
      return const Right(null);
    } catch (_) {
      return const Left(DatabaseFailure());
    }
  }

  Future<Either<Failure, bool>> isFavorite(int id) async {
    try {
      final db = await instance.database;
      final maps = await db.query(
        'favorites',
        where: 'id = ?',
        whereArgs: [id],
      );
      return Right(maps.isNotEmpty);
    } catch (_) {
      return const Left(DatabaseFailure());
    }
  }

  Future<Either<Failure, List<MusicModel>>> getFavorites() async {
    try {
      final db = await instance.database;
      final maps = await db.query('favorites', orderBy: 'timestamp DESC');
      return Right(maps.map((e) => MusicModel.fromMap(e)).toList());
    } catch (_) {
      return const Left(DatabaseFailure());
    }
  }

  // --- Playlists Methods ---

  Future<Either<Failure, int>> createPlaylist(String name) async {
    try {
      final db = await instance.database;
      final id = await db.insert('playlists', {
        'name': name,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });
      return Right(id);
    } catch (_) {
      return const Left(DatabaseFailure());
    }
  }

  Future<Either<Failure, List<Map<String, dynamic>>>> getPlaylists() async {
    try {
      final db = await instance.database;
      return Right(await db.query('playlists', orderBy: 'createdAt DESC'));
    } catch (_) {
      return const Left(DatabaseFailure());
    }
  }

  Future<Either<Failure, void>> deletePlaylist(int id) async {
    try {
      final db = await instance.database;
      await db.delete('playlists', where: 'id = ?', whereArgs: [id]);
      return const Right(null);
    } catch (_) {
      return const Left(DatabaseFailure());
    }
  }

  Future<Either<Failure, void>> addSongToPlaylist({
    required int playlistId,
    required MusicModel song,
  }) async {
    try {
      final db = await instance.database;
      await db.insert('playlist_songs', {
        'playlistId': playlistId,
        'songId': song.id,
        'songPath': song.path,
        'songTitle': song.title,
        'songArtist': song.artist,
        'songAlbum': song.album,
        'songDuration': song.duration,
        'songSize': song.size,
      });
      return const Right(null);
    } catch (_) {
      return const Left(DatabaseFailure());
    }
  }

  Future<Either<Failure, void>> removeSongFromPlaylist(
    int playlistId,
    int songId,
  ) async {
    try {
      final db = await instance.database;
      await db.delete(
        'playlist_songs',
        where: 'playlistId = ? AND songId = ?',
        whereArgs: [playlistId, songId],
      );
      return const Right(null);
    } catch (_) {
      return const Left(DatabaseFailure());
    }
  }

  Future<Either<Failure, List<MusicModel>>> getPlaylistSongs(
    int playlistId,
  ) async {
    try {
      final db = await instance.database;
      final maps = await db.query(
        'playlist_songs',
        where: 'playlistId = ?',
        whereArgs: [playlistId],
      );
      return Right(maps.map((e) => MusicModel.fromMap(e)).toList());
    } catch (_) {
      return const Left(DatabaseFailure());
    }
  }
}
