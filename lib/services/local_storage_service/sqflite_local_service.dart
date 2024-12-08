import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalStorage {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDatabase();
      return _database!;
    }
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'post_database.db');
    return openDatabase(path, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE posts (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          userId INTEGER,
          postId INTEGER,
          title TEXT,
          body TEXT
        )
      ''');
    }, version: 1);
  }

  static Future<void> insertPost(int? userId, int? postId, String? title, String? body) async {
    final db = await database;
    await db.insert(
      'posts',
      {
        'userId': userId,
        'postId': postId,
        'title': title,
        'body': body,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getPosts() async {
    final db = await database;
    return await db.query('posts');
  }

  static Future<Map<String, dynamic>?> getPostByPostId(int postId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'posts',
      where: 'postId = ?',
      whereArgs: [postId],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }
}
