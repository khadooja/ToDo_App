import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_new/domain/entities/task.dart';
import 'package:todo_app_new/domain/repositories/task_repository.dart';
import 'package:todo_app_new/data/repositories/task_repository_impl.dart';
import 'package:todo_app_new/data/datasources/task_local_data_source.dart';

final taskLocalDataSourceProvider = Provider<TaskLocalDataSource>((ref) {
  return TaskLocalDataSource();
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepositoryImpl(ref.watch(taskLocalDataSourceProvider));
});

/// Owns the task list. Replaces the old `TaskController extends GetxController`.
///
/// Using AsyncNotifier gives loading/error/data states for free via
/// AsyncValue, instead of the old approach where the empty-state
/// illustration was shown indistinguishably during the initial load AND
/// when there really were zero tasks, and DB failures were silently
/// swallowed with no user-visible error state at all.
class TaskListNotifier extends AsyncNotifier<List<Task>> {
  @override
  Future<List<Task>> build() {
    return ref.read(taskRepositoryProvider).getTasks();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => ref.read(taskRepositoryProvider).getTasks(),
    );
  }

  Future<void> addTask(Task task) async {
    await ref.read(taskRepositoryProvider).addTask(task);
    await refresh();
  }

  Future<void> updateTask(Task task) async {
    await ref.read(taskRepositoryProvider).updateTask(task);
    await refresh();
  }

  Future<void> deleteTask(Task task) async {
    await ref.read(taskRepositoryProvider).deleteTask(task);
    await refresh();
  }

  Future<void> deleteAll() async {
    await ref.read(taskRepositoryProvider).deleteAllTasks();
    await refresh();
  }

  Future<void> markCompleted(int id) async {
    await ref.read(taskRepositoryProvider).markTaskCompleted(id);
    await refresh();
  }
}

final taskListProvider = AsyncNotifierProvider<TaskListNotifier, List<Task>>(
  TaskListNotifier.new,
);
