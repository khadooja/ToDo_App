import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart' show inMemoryDatabasePath;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:todo_app_new/domain/entities/task.dart';
import 'package:todo_app_new/data/datasources/task_local_data_source.dart';
import 'package:todo_app_new/data/repositories/task_repository_impl.dart';

void main() {
  // sqflite needs a real (or ffi) SQLite engine; the default plugin channel
  // isn't available in `flutter test`. sqflite_common_ffi gives us that
  // without needing a device/emulator, so this test actually exercises the
  // real SQL rather than mocking the data source away entirely.
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late TaskLocalDataSource dataSource;
  late TaskRepositoryImpl repository;

  setUp(() {
    // In-memory DB, fresh per test. singleInstance:false (set in
    // TaskLocalDataSource) ensures this doesn't reuse a cached connection
    // from a previous test just because the path string is identical.
    dataSource = TaskLocalDataSource(databasePath: inMemoryDatabasePath);
    repository = TaskRepositoryImpl(dataSource);
  });

  tearDown(() => dataSource.close());

  Task buildTask({int? id, String title = 'Sample task'}) {
    return Task(
      id: id,
      title: title,
      note: 'Some note',
      date: DateTime(2026, 5, 20),
      startTime: const TimeOfDay(hour: 9, minute: 0),
      endTime: const TimeOfDay(hour: 9, minute: 30),
      color: TaskColor.orange,
      remind: 10,
      repeat: RepeatType.daily,
    );
  }

  group('TaskRepositoryImpl', () {
    test('getTasks returns an empty list before anything is added', () async {
      final tasks = await repository.getTasks();
      expect(tasks, isEmpty);
    });

    test('addTask then getTasks returns the inserted task', () async {
      await repository.addTask(buildTask(title: 'Buy groceries'));

      final tasks = await repository.getTasks();

      expect(tasks, hasLength(1));
      expect(tasks.first.title, 'Buy groceries');
      expect(tasks.first.repeat, RepeatType.daily);
    });

    test('updateTask changes the stored task in place', () async {
      await repository.addTask(buildTask(title: 'Original'));
      final inserted = (await repository.getTasks()).first;

      await repository.updateTask(inserted.copyWith(title: 'Updated'));

      final tasks = await repository.getTasks();
      expect(tasks, hasLength(1));
      expect(tasks.first.title, 'Updated');
    });

    test('deleteTask removes only the targeted task', () async {
      await repository.addTask(buildTask(title: 'Keep me'));
      await repository.addTask(buildTask(title: 'Delete me'));
      final tasks = await repository.getTasks();
      final toDelete = tasks.firstWhere((t) => t.title == 'Delete me');

      await repository.deleteTask(toDelete);

      final remaining = await repository.getTasks();
      expect(remaining, hasLength(1));
      expect(remaining.first.title, 'Keep me');
    });

    test('deleteAllTasks empties the table', () async {
      await repository.addTask(buildTask(title: 'One'));
      await repository.addTask(buildTask(title: 'Two'));

      await repository.deleteAllTasks();

      expect(await repository.getTasks(), isEmpty);
    });

    test('markTaskCompleted flips isCompleted to true', () async {
      await repository.addTask(buildTask(title: 'Finish this'));
      final inserted = (await repository.getTasks()).first;
      expect(inserted.isCompleted, isFalse);

      await repository.markTaskCompleted(inserted.id!);

      final tasks = await repository.getTasks();
      expect(tasks.first.isCompleted, isTrue);
    });
  });
}
