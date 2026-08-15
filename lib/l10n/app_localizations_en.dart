// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get myTasks => 'My Tasks';

  @override
  String get addTask => 'Add Task';

  @override
  String get editTask => 'Edit Task';

  @override
  String get noTasksYetTitle => 'You don\'t have any tasks yet!';

  @override
  String get noTasksYetSubtitle => 'Tap on the + button to add a new task';

  @override
  String get noTasksForDateTitle => 'No tasks for this date.';

  @override
  String get noTasksForDateSubtitle => 'Try another day or add a new task';

  @override
  String get deleteAllTasksTitle => 'Delete All Tasks';

  @override
  String get deleteAllTasksConfirm =>
      'Are you sure you want to delete all tasks?';

  @override
  String get deleteTaskTitle => 'Delete Task';

  @override
  String get deleteTaskConfirm => 'Are you sure you want to delete this task?';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get close => 'Close';

  @override
  String get titleField => 'Title';

  @override
  String get noteField => 'Note';

  @override
  String get dateField => 'Date';

  @override
  String get startTimeField => 'Start Time';

  @override
  String get endTimeField => 'End Time';

  @override
  String get remindField => 'Remind';

  @override
  String get repeatField => 'Repeat';

  @override
  String get colorField => 'Color';

  @override
  String get createTaskButton => 'Create Task';

  @override
  String get updateTaskButton => 'Update Task';

  @override
  String get requiredFieldsTitle => 'Required';

  @override
  String get requiredFieldsMessage => 'All fields are required!';

  @override
  String get taskUpdatedTitle => 'Task Updated';

  @override
  String get taskUpdatedMessage => 'The task has been successfully updated!';

  @override
  String get darkModeLabel => 'Dark Mode';

  @override
  String get notificationsLabel => 'Notifications';

  @override
  String get todoOptionsHeader => 'Todo Options';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get sectionMorning => 'Morning';

  @override
  String get sectionAfternoon => 'Afternoon';

  @override
  String get sectionEvening => 'Evening';

  @override
  String taskCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks',
      one: '1 task',
      zero: 'No tasks',
    );
    return '$_temp0';
  }
}
