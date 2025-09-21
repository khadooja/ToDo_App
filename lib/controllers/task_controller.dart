import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/models/task.dart';

class TaskController extends GetxController {
  final taskList = [
    Task(
      title: 'title',
      note: 'note',
      startTime: DateFormat('HH:mm')
          .format(DateTime.now().add(const Duration(hours: 1)))
          .toString(),
      endTime: '10:00 AM',
      color: 2,
      isCompleted: 1,
    ),
    Task(
      title: 'title',
      note: 'note',
      startTime: DateFormat('HH:mm')
          .format(DateTime.now().add(const Duration(hours: 1)))
          .toString(),
      endTime: '10:00 AM',
      color: 2,
      isCompleted: 1,
    ),
  ];
  getTasks() {
    return taskList;
  }
  addTask({Task? task}){
    
  }
}
