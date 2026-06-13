import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'laperbang.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE favorites(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            vendor_id TEXT UNIQUE,
            nama TEXT,
            kategori TEXT,
            lat REAL,
            lng REAL
          )
        ''');
      },
    );
  }

  Future<void> insertFavorite(Map<String, dynamic> data) async {
    final db = await database;
    await db.insert(
      'favorites',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteFavorite(String vendorId) async {
    final db = await database;
    await db.delete('favorites', where: 'vendor_id = ?', whereArgs: [vendorId]);
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await database;
    return await db.query('favorites');
  }

  Future<bool> isFavorite(String vendorId) async {
    final db = await database;
    final maps = await db.query(
      'favorites',
      where: 'vendor_id = ?',
      whereArgs: [vendorId],
    );
    return maps.isNotEmpty;
  }
}
