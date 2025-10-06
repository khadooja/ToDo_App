import 'package:get/get.dart';
import 'package:todo/data/db/db_helper.dart';
import 'package:todo/data/models/task.dart';

class TaskController extends GetxController {
  final taskList = [Task()].obs;
  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
    update();
  }

  //Future<int> addTask({Task? task}) {
    //return DBHelper.insert(task);
//  }

Future<int> addTask({Task? task}) async {
  int id = await DBHelper.insert(task); 
  getTasks(); 
  return id; 
}

  Future<int> updateTask(int id, Task task) async {
    int result = await DBHelper.updateTask(id, task);
    getTasks();
    return result;
  }

  void delete(Task task) async {
    await DBHelper.delete(task);
    getTasks();
  }

  void markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTasks();
  }

  void deleteAll(Task task) async {
    await DBHelper.deleteAll(task);
    getTasks();
  }
}
