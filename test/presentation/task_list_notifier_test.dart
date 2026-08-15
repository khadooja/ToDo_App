import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_new/domain/entities/task.dart';
import 'package:todo_app_new/domain/repositories/task_repository.dart';
import 'package:todo_app_new/presentation/providers/task_providers.dart';

/// In-memory fake — this is the whole point of having TaskRepository as an
/// interface. The old TaskController couldn't be tested this way at all,
/// since it called DBHelper's static methods directly.
class FakeTaskRepository implements TaskRepository {
  final List<Task> _tasks = [];
  int _nextId = 1;

  @override
  Future<List<Task>> getTasks() async => List.unmodifiable(_tasks);

  @override
  Future<int> addTask(Task task) async {
    final id = _nextId++;
    _tasks.add(task.copyWith(id: id));
    return id;
  }

  @override
  Future<int> updateTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index == -1) return 0;
    _tasks[index] = task;
    return 1;
  }

  @override
  Future<int> deleteTask(Task task) async {
    final removed = _tasks.remove(_tasks.firstWhere((t) => t.id == task.id));
    return removed ? 1 : 0;
  }

  @override
  Future<int> deleteAllTasks() async {
    final count = _tasks.length;
    _tasks.clear();
    return count;
  }

  @override
  Future<int> markTaskCompleted(int id) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return 0;
    _tasks[index] = _tasks[index].copyWith(isCompleted: true);
    return 1;
  }
}

Task _buildTask({String title = 'Test task'}) {
  return Task(
    title: title,
    note: 'note',
    date: DateTime(2026, 6, 1),
    startTime: const TimeOfDay(hour: 8, minute: 0),
    endTime: const TimeOfDay(hour: 8, minute: 30),
  );
}

void main() {
  late FakeTaskRepository fakeRepository;
  late ProviderContainer container;

  setUp(() {
    fakeRepository = FakeTaskRepository();
    container = ProviderContainer(
      overrides: [
        taskRepositoryProvider.overrideWithValue(fakeRepository),
      ],
    );
  });

  tearDown(() => container.dispose());

  test('build() loads whatever the repository currently has', () async {
    await fakeRepository.addTask(_buildTask(title: 'Pre-existing'));

    final tasks = await container.read(taskListProvider.future);

    expect(tasks, hasLength(1));
    expect(tasks.first.title, 'Pre-existing');
  });

  test('addTask adds to the repository and refreshes state', () async {
    await container.read(taskListProvider.future); // wait for initial build

    await container.read(taskListProvider.notifier).addTask(_buildTask(title: 'New task'));

    final state = container.read(taskListProvider);
    expect(state.value, hasLength(1));
    expect(state.value!.first.title, 'New task');
  });

  test('deleteTask removes just the targeted task', () async {
    await fakeRepository.addTask(_buildTask(title: 'Keep'));
    await fakeRepository.addTask(_buildTask(title: 'Remove'));
    await container.read(taskListProvider.future);

    final toRemove =
        container.read(taskListProvider).value!.firstWhere((t) => t.title == 'Remove');
    await container.read(taskListProvider.notifier).deleteTask(toRemove);

    final state = container.read(taskListProvider);
    expect(state.value, hasLength(1));
    expect(state.value!.first.title, 'Keep');
  });

  test('deleteAll empties the list', () async {
    await fakeRepository.addTask(_buildTask());
    await fakeRepository.addTask(_buildTask());
    await container.read(taskListProvider.future);

    await container.read(taskListProvider.notifier).deleteAll();

    expect(container.read(taskListProvider).value, isEmpty);
  });

  test('markCompleted flips isCompleted on the right task', () async {
    await fakeRepository.addTask(_buildTask());
    await container.read(taskListProvider.future);
    final task = container.read(taskListProvider).value!.first;

    await container.read(taskListProvider.notifier).markCompleted(task.id!);

    expect(container.read(taskListProvider).value!.first.isCompleted, isTrue);
  });
}
