import 'package:todo_app_new/domain/entities/task.dart';



/// Contract the presentation layer depends on. It has no idea SQLite exists
/// behind it — that's the whole point. Before this refactor, TaskController
/// called DBHelper's *static* methods directly, which meant:
///  - no way to swap the data source (e.g. for tests, or a future backend)
///  - no way to mock it in a unit test
/// TaskRepositoryImpl (data layer) is the only class that implements this.
abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Future<int> addTask(Task task);
  Future<int> updateTask(Task task);
  Future<int> deleteTask(Task task);
  Future<int> deleteAllTasks();
  Future<int> markTaskCompleted(int id);
}
