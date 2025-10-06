import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo/data/models/task.dart';
import 'dart:developer' as dev;

class DBHelper {
  static Database? _db;
  static const int _version = 2;
  static const String _tableName = 'tasks';

  static Future<Database> get database async {
    if (_db != null) return _db!;
    await initDb();
    return _db!;
  }

  /// تهيئة قاعدة البيانات
  static Future<void> initDb() async {
    if (_db != null) return;

    try {
      String dbPath = await getDatabasesPath();
      String path = join(dbPath, 'task.db');

      _db = await openDatabase(
        path,
        version: _version,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE $_tableName (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title STRING,
              note TEXT,
              date STRING,
              startTime STRING,
              endTime STRING,
              remind INTEGER,
              repeat STRING,
              color INTEGER,
              isCompleted INTEGER,
              priority INTEGER
            )
          ''');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          await db.execute('DROP TABLE IF EXISTS $_tableName');
          await db.execute('''
            CREATE TABLE $_tableName (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title STRING,
              note TEXT,
              date STRING,
              startTime STRING,
              endTime STRING,
              remind INTEGER,
              repeat STRING,
              color INTEGER,
              isCompleted INTEGER,
              priority INTEGER
            )
          ''');
        },
      );
      dev.log('✅ Database initialized successfully at: $path');
    } catch (e) {
      dev.log('❌ Database init error: $e');
    }
  }

  static Future<int> insert(Task task) async {
    final db = await database;
    return await db.insert(_tableName, task.toJson());
  }


  static Future<List<Map<String, dynamic>>> query() async {
    final db = await database;
    return await db.query(_tableName);
  }


  static Future<int> delete(Task task) async {
    final db = await database;
    return await db.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }
  static Future<int> deleteAll() async {
    final db = await database;
    return await db.delete(_tableName);
  }

  static Future<int> updateCompleted(int id) async {
    final db = await database;
    return await db.rawUpdate(
      '''
      UPDATE $_tableName
      SET isCompleted = ?
      WHERE id = ?
      ''',
      [1, id],
    );
  }

  static Future<int> updateTask(int id, Task task) async {
    final db = await database;
    return await db.update(
      _tableName,
      task.toJson(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
