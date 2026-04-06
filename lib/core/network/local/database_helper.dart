import 'package:path/path.dart';
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

  Future<void> addFavorite(MusicModel song) async {
    final db = await instance.database;
    await db.insert(
      'favorites',
      {
        ...song.toMap(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(int id) async {
    final db = await instance.database;
    await db.delete(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> isFavorite(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty;
  }

  Future<List<MusicModel>> getFavorites() async {
    final db = await instance.database;
    final maps = await db.query(
      'favorites',
      orderBy: 'timestamp DESC',
    );

    return maps.map((e) => MusicModel.fromMap(e)).toList();
  }

  // --- Playlists Methods ---

  Future<int> createPlaylist(String name) async {
    final db = await instance.database;
    return await db.insert('playlists', {
      'name': name,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<List<Map<String, dynamic>>> getPlaylists() async {
    final db = await instance.database;
    return await db.query('playlists', orderBy: 'createdAt DESC');
  }

  Future<void> deletePlaylist(int id) async {
    final db = await instance.database;
    await db.delete('playlists', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> addSongToPlaylist({
    required int playlistId,
    required MusicModel song,
  }) async {
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
  }

  Future<void> removeSongFromPlaylist(int playlistId, int songId) async {
    final db = await instance.database;
    await db.delete(
      'playlist_songs',
      where: 'playlistId = ? AND songId = ?',
      whereArgs: [playlistId, songId],
    );
  }

  Future<List<MusicModel>> getPlaylistSongs(int playlistId) async {
    final db = await instance.database;
    final maps = await db.query(
      'playlist_songs',
      where: 'playlistId = ?',
      whereArgs: [playlistId],
    );

    return maps.map((e) => MusicModel.fromMap(e)).toList();
  }
}
