import 'package:path/path.dart';
import 'package:pulse/core/models/song_model.dart';
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
        timestamp INTEGER DEFAULT 0  -- Add timestamp column for sorting
      )
    ''');
  }

  Future<void> addFavorite(SongModel song) async {
    final db = await instance.database;
    await db.insert(
      'favorites',
      {
        'id': song.id,
        'path': song.path,
        'title': song.title,
        'artist': song.artist,
        'timestamp': DateTime.now().millisecondsSinceEpoch, // Use current time
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

  Future<List<SongModel>> getFavorites() async {
    final db = await instance.database;
    final maps = await db.query(
      'favorites',
      orderBy: 'timestamp DESC', // Sort by timestamp, newest first
    );

    return maps.map((e) {
      return SongModel(
        id: e['id'] as int,
        path: e['path'] as String,
        title: e['title'] as String,
        artist: e['artist'] as String,
      );
    }).toList();
  }
}
