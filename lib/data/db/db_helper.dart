import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo/data/models/task.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 2;
  static const String _tableName = 'tasks';
 static Future<void> initDb() async {
  if (_db != null) {
    return;
  }
  try {
    String _path = await getDatabasesPath();
    String path = join(_path, 'task.db');

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
            isCompleted INTEGER
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // نحذف الجدول القديم إذا موجود
        await db.execute('DROP TABLE IF EXISTS $_tableName');

        // نعيد إنشاؤه من جديد
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
            isCompleted INTEGER
          )
        ''');
      },
    );
  } catch (e) {
    print('❌ Database init error: $e');
  }
}


  static Future<int> insert(Task? task) async {
    print('insert function called');
    return await _db?.insert(_tableName, task!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print('query function called');
    return await _db!.query(_tableName);
  }

  static delete(Task task) async {
    return await _db!.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }

  static Future<int> deleteAll(Task task) async {
    return await _db!.delete(_tableName);
  }

  static update(int id) async {
    return await _db!.rawUpdate('''
    UPDATE tasks
    SET isCompleted = ?
    WHERE id = ?
    ''', [1, id]);
  }
  static Future<int> updateTask(int id, Task task) async {
  final db = _db;
  return await db!.update(
    'tasks',
    task.toJson(),
    where: 'id = ?',
    whereArgs: [id],
  );
}

}
