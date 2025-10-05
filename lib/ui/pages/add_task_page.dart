import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/ThemeData/text_styles.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/models/task.dart';
import 'package:todo/ThemeData/colors.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime =
      DateFormat(
        'hh:mm a',
      ).format(DateTime.now().add(const Duration(minutes: 15))).toString();
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int _selectedColor = 0;
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
              Text("Add Task", style: headingStyle),
              InputField(
                title: 'Title',
                hint: 'Enter title here',
                controller: _titleController,
              ),
              SizedBox(height: 12),
              InputField(
                title: 'Note',
                hint: 'Enter Note here',
                controller: _noteController,
              ),
              SizedBox(height: 12),
              InputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: () {
                    getDateFromeUser();
                  },
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
                        hint: _startTime,
                        widget: Align(
                          alignment: Alignment.centerRight, // أيقونة أقصى يمين
                          child: IconButton(
                            onPressed: () {
                              getTimeFromUser(isStartTime: true);
                            },
                            icon: const Icon(Icons.access_time_rounded),
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                      ), // مسافة بين الحقلين
                      child: InputField(
                        title: 'End Time',
                        hint: _endTime,
                        widget: Align(
                          alignment: Alignment.centerRight, // أيقونة أقصى يمين
                          child: IconButton(
                            onPressed: () {
                              getTimeFromUser(isStartTime: false);
                            },
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
                    DropdownButton(
                      borderRadius: BorderRadius.circular(10),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      iconSize: 32,
                      elevation: 4,
                      style: subtitelStyle,
                      underline: Container(height: 0),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedRemind = int.parse(newValue!);
                        });
                      },
                      items:
                          remindList.map<DropdownMenuItem<String>>((int value) {
                            return DropdownMenuItem<String>(
                              value: value.toString(),
                              child: Text(value.toString()),
                            );
                          }).toList(),
                    ),
                    const SizedBox(width: 6),
                  ],
                ),
              ),
              InputField(
                title: 'Repeat',
                hint: _selectedRepeat,
                widget: Row(
                  children: [
                    DropdownButton(
                      borderRadius: BorderRadius.circular(10),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      iconSize: 32,
                      elevation: 4,
                      style: subtitelStyle,
                      underline: Container(height: 0),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedRepeat = newValue!;
                        });
                      },
                      items:
                          repeatList.map<DropdownMenuItem<String>>((
                            String value,
                          ) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
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
                  Expanded(child: _colorePalete()), // <-- مهم
                  const SizedBox(width: 10), // مسافة بسيطة
                  MyButton(
                    label: "Create Task",
                    onTap: () {
                      _validateDate();
                    },
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
    elevation: 0, // إزالة الظل
    backgroundColor: context.theme.scaffoldBackgroundColor, // لون موحد
    shadowColor: Colors.transparent, // إزالة أي ظل محتمل
    surfaceTintColor: Colors.transparent, // مهم لبعض الإصدارات الجديدة
    leading: IconButton(
      onPressed: () {
        Get.back();
      },
      icon: Icon(
        Icons.arrow_back_ios,
        size: 24,
        color: isDark ? Colors.white : Colors.black87,
      ),
    ),
    actions: [
      CircleAvatar(
        radius: 18,
        backgroundColor: isDark ? Colors.grey[300] : Colors.grey[700],
        child: Icon(
          Icons.person,
          color: isDark ? Colors.black87 : Colors.white,
          size: 20,
        ),
      ),
      const SizedBox(width: 20),
    ],
  );
}


  _addTaskToDb() async {
    int value = await _taskController.addTask(
      task: Task(
        title: _titleController.text,
        note: _noteController.text,
        isCompleted: 0,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        color: _selectedColor,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
      ),
    );
    print('############### ID: $value ###############');

    //Get.back();
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        "Required",
        "All fields are required !",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.red),
      );
    } else {
      print('############### SOMETHING WENT WRONG ###############');
    }
  }

  Column _colorePalete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Color', style: titelStyle),
        const SizedBox(height: 8),
        Wrap(
          children: List<Widget>.generate(3, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor:
                      index == 0
                          ? primaryClr
                          : index == 1
                          ? pinkClr
                          : orangeClr,
                  child:
                      _selectedColor == index
                          ? const Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 16,
                          )
                          : null,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  getDateFromeUser() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2121),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      } else {
        setState(() {
          _selectedDate = pickedDate;
        });
      }
    });
  }

  void getTimeFromUser({required bool isStartTime}) {
    showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime:
          isStartTime
              ? TimeOfDay.fromDateTime(DateTime.now())
              : TimeOfDay.fromDateTime(
                DateTime.now().add(const Duration(minutes: 15)),
              ),
    ).then((pickedTime) {
      if (pickedTime == null) {
        return;
      } else {
        String formatedTime = pickedTime.format(context);
        if (isStartTime) {
          setState(() {
            _startTime = formatedTime;
          });
        } else {
          setState(() {
            _endTime = formatedTime;
          });
        }
      }
    });
  }
}
