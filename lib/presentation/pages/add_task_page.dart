import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_new/core/Theme/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_new/domain/entities/task.dart';
import 'package:todo_app_new/core/Theme/text_styles.dart';
import 'package:todo_app_new/presentation/widgets/button.dart';
import 'package:todo_app_new/presentation/widgets/input_field.dart';
import 'package:todo_app_new/presentation/widgets/app_snackbar.dart';
import 'package:todo_app_new/presentation/providers/task_providers.dart';


class AddTaskPage extends ConsumerStatefulWidget {
  final Task? task; // nullable task
  const AddTaskPage({super.key, this.task});

  @override
  ConsumerState<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends ConsumerState<AddTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.fromDateTime(
    DateTime.now().add(const Duration(minutes: 15)),
  );
  int _selectedRemind = 5;
  final List<int> remindList = [5, 10, 15, 20];
  RepeatType _selectedRepeat = RepeatType.none;
  // BUG FIX carried over from Phase 1: home_page.dart's filtering and
  // notification_services.dart's scheduling both already had branches for
  // Yearly, but it was never selectable here. RepeatType.values now covers
  // all of them by construction, so this can't drift out of sync again.
  final List<RepeatType> repeatList = RepeatType.values;
  TaskColor _selectedColor = TaskColor.blue;

  @override
  void initState() {
    super.initState();

    final task = widget.task;
    if (task != null) {
      _titleController.text = task.title;
      _noteController.text = task.note;
      _selectedDate = task.date;
      _startTime = task.startTime;
      _endTime = task.endTime;
      _selectedRemind = task.remind;
      _selectedRepeat = task.repeat;
      _selectedColor = task.color;
    }
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.task == null ? "Add Task" : "Edit Task", style: headingStyle),
              InputField(
                title: 'Title',
                hint: 'Enter title here',
                controller: _titleController,
              ),
              const SizedBox(height: 12),
              InputField(
                title: 'Note',
                hint: 'Enter Note here',
                controller: _noteController,
              ),
              const SizedBox(height: 12),
              InputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: getDateFromUser,
                  icon: const Icon(Icons.calendar_today_outlined),
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 12),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: InputField(
                        title: 'Start Time',
                        hint: _formatTime(_startTime),
                        widget: Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () => getTimeFromUser(isStartTime: true),
                            icon: const Icon(Icons.access_time_rounded),
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: InputField(
                        title: 'End Time',
                        hint: _formatTime(_endTime),
                        widget: Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () => getTimeFromUser(isStartTime: false),
                            icon: const Icon(Icons.access_time_rounded),
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              InputField(
                title: 'Remind',
                hint: '$_selectedRemind minutes early',
                widget: Row(
                  children: [
                    DropdownButton<int>(
                      borderRadius: BorderRadius.circular(10),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      iconSize: 32,
                      elevation: 4,
                      style: subtitelStyle,
                      underline: Container(height: 0),
                      value: _selectedRemind,
                      onChanged: (int? newValue) {
                        setState(() => _selectedRemind = newValue!);
                      },
                      items: remindList
                          .map((value) => DropdownMenuItem(
                                value: value,
                                child: Text(value.toString()),
                              ))
                          .toList(),
                    ),
                    const SizedBox(width: 6),
                  ],
                ),
              ),
              InputField(
                title: 'Repeat',
                hint: _selectedRepeat.label,
                widget: Row(
                  children: [
                    DropdownButton<RepeatType>(
                      borderRadius: BorderRadius.circular(10),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      iconSize: 32,
                      elevation: 4,
                      style: subtitelStyle,
                      underline: Container(height: 0),
                      value: _selectedRepeat,
                      onChanged: (RepeatType? newValue) {
                        setState(() => _selectedRepeat = newValue!);
                      },
                      items: repeatList
                          .map((repeat) => DropdownMenuItem(
                                value: repeat,
                                child: Text(repeat.label),
                              ))
                          .toList(),
                    ),
                    const SizedBox(width: 6),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: _colorPalette()),
                  const SizedBox(width: 10),
                  MyButton(
                    label: widget.task == null ? "Create Task" : "Update Task",
                    onTap: _onSubmit,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    bool isDark = Get.isDarkMode;
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.scaffoldBackgroundColor,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        tooltip: 'Back',
        onPressed: () => Get.back(),
        icon: Icon(
          Icons.arrow_back_ios,
          size: 24,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  void _onSubmit() {
    if (_titleController.text.trim().isEmpty ||
        _noteController.text.trim().isEmpty) {
      AppSnackbar.error("Required", "All fields are required!");
      return;
    }

    final task = Task(
      id: widget.task?.id,
      title: _titleController.text.trim(),
      note: _noteController.text.trim(),
      isCompleted: widget.task?.isCompleted ?? false,
      date: _selectedDate,
      startTime: _startTime,
      endTime: _endTime,
      color: _selectedColor,
      remind: _selectedRemind,
      repeat: _selectedRepeat,
    );

    if (widget.task == null) {
      ref.read(taskListProvider.notifier).addTask(task);
    } else {
      ref.read(taskListProvider.notifier).updateTask(task);
      AppSnackbar.success(
        "Task Updated",
        "The task has been successfully updated!",
      );
    }

    Get.back();
  }

  Widget _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Color', style: titelStyle),
        const SizedBox(height: 8),
        Wrap(
          children: TaskColor.values.map((color) {
            return GestureDetector(
              onTap: () => setState(() => _selectedColor = color),
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: _colorFor(color),
                  child: _selectedColor == color
                      ? const Icon(Icons.done, color: Colors.white, size: 16)
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _colorFor(TaskColor color) {
    switch (color) {
      case TaskColor.blue:
        return primaryClr;
      case TaskColor.pink:
        return pinkClr;
      case TaskColor.orange:
        return orangeClr;
    }
  }

  void getDateFromUser() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2121),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() => _selectedDate = pickedDate);
    });
  }

  void getTimeFromUser({required bool isStartTime}) {
    showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
    ).then((pickedTime) {
      if (pickedTime == null) return;
      setState(() {
        if (isStartTime) {
          _startTime = pickedTime;
        } else {
          _endTime = pickedTime;
        }
      });
    });
  }
}
