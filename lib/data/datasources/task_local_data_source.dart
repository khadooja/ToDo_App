import 'dart:developer' as dev;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
 
/// Raw SQLite access, instance-based (unlike the old static `DBHelper`) so
/// it can be constructed by a Riverpod provider and swapped for a fake data
/// source in tests without touching global static state.
class TaskLocalDataSource {
  // Optional override lets tests point at an in-memory DB (sqflite's
  // `inMemoryDatabasePath`) so each test run gets a clean, isolated
  // database instead of sharing the real on-disk file. Production code
  // never passes this, so real usage is unaffected.
  TaskLocalDataSource({String? databasePath}) : _overridePath = databasePath;
 
  final String? _overridePath;
 
  static const int _version = 2;
  static const String _tableName = 'tasks';
 
  Database? _db;
 
  static const String _createTableQuery = '''
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
  ''';
 
  Future<Database> get _database async {
    if (_db != null) return _db!;
    try {
      final path = _overridePath ?? join(await getDatabasesPath(), 'task.db');
      _db = await openDatabase(
        path,
        version: _version,
        // BUG FIX: openDatabase defaults to singleInstance: true, which
        // caches and reuses the same connection for repeated calls with
        // the same path string. This class already caches _db itself
        // (see the guard above), so sqflite's own caching is redundant —
        // and for in-memory test databases it's actively harmful: every
        // TaskLocalDataSource created with the literal ':memory:' path
        // (sqflite's `inMemoryDatabasePath`) was silently reusing the same
        // underlying connection and leaking state between tests.
        singleInstance: false,
        onCreate: (db, version) async => db.execute(_createTableQuery),
        // BUG FIX carried over from Phase 1: this used to DROP TABLE and
        // recreate it on every version bump, permanently deleting all of
        // the user's tasks. Future schema changes belong here as guarded
        // ALTER TABLE statements, one `if` block per version, e.g.:
        //
        // if (oldVersion < 3) {
        //   await db.execute('ALTER TABLE $_tableName ADD COLUMN foo TEXT');
        // }
        onUpgrade: (db, oldVersion, newVersion) async {
          dev.log('DB upgrade from $oldVersion to $newVersion (no-op: schema unchanged)');
        },
      );
      dev.log('✅ Database initialized successfully at: $path');
    } catch (e) {
      dev.log('❌ Database init error: $e');
      rethrow;
    }
    return _db!;
  }
 
  Future<int> insert(Map<String, dynamic> row) async {
    final db = await _database;
    return db.insert(_tableName, row);
  }
 
  Future<List<Map<String, dynamic>>> queryAll() async {
    final db = await _database;
    return db.query(_tableName);
  }
 
  Future<int> update(int id, Map<String, dynamic> row) async {
    final db = await _database;
    return db.update(_tableName, row, where: 'id = ?', whereArgs: [id]);
  }
 
  Future<int> delete(int id) async {
    final db = await _database;
    return db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
 
  Future<int> deleteAll() async {
    final db = await _database;
    return db.delete(_tableName);
  }
 
  Future<int> updateCompleted(int id) async {
    final db = await _database;
    return db.rawUpdate(
      'UPDATE $_tableName SET isCompleted = ? WHERE id = ?',
      [1, id],
    );
  }
 
  /// Releases the underlying connection. Mainly useful in tests
  /// (tearDown) so each test's in-memory DB doesn't linger.
  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
 