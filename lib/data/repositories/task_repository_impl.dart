import 'package:todo_app_new/data/db/task_dto.dart';
import 'package:todo_app_new/domain/entities/task.dart';
import 'package:todo_app_new/domain/repositories/task_repository.dart';
import 'package:todo_app_new/data/datasources/task_local_data_source.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource _dataSource;

  TaskRepositoryImpl(this._dataSource);

  @override
  Future<List<Task>> getTasks() async {
    final rows = await _dataSource.queryAll();
    return rows.map(TaskDto.fromMap).toList();
  }

  @override
  Future<int> addTask(Task task) {
    return _dataSource.insert(TaskDto.toMap(task));
  }

  @override
  Future<int> updateTask(Task task) {
    return _dataSource.update(task.id!, TaskDto.toMap(task));
  }

  @override
  Future<int> deleteTask(Task task) {
    return _dataSource.delete(task.id!);
  }

  @override
  Future<int> deleteAllTasks() {
    return _dataSource.deleteAll();
  }

  @override
  Future<int> markTaskCompleted(int id) {
    return _dataSource.updateCompleted(id);
  }
}
