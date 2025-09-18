import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/services/theme_services.dart';
import 'package:todo/ui/theme.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int _selectedColor = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Task",
                style: headingStyle,
              ),
              InputField(
                title: 'Title',
                hint: 'Enter title here',
                controller: _titleController,
              ),
              InputField(
                title: 'Note',
                hint: 'Enter Note here',
                controller: _noteController,
              ),
              InputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.calendar_today_outlined),
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: 'Start Time',
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.access_time_rounded),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(
                    child: InputField(
                      title: 'End Time',
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.access_time_rounded),
                        color: Colors.grey,
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
                        underline: Container(
                          height: 0,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedRemind = int.parse(newValue!);
                          });
                        },
                        items: remindList
                            .map<DropdownMenuItem<String>>((int value) {
                          return DropdownMenuItem<String>(
                            value: value.toString(),
                            child: Text(value.toString()),
                          );
                        }).toList(),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                    ],
                  )),
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
                        underline: Container(
                          height: 0,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedRepeat = newValue!;
                          });
                        },
                        items: repeatList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                    ],
                  )),
              const SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorePalete(),
                  MyButton(
                    label: "create Task",
                    onTap: () {
                      Get.back();
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
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.scaffoldBackgroundColor,
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 24,
          color: Colors.grey,
        ),
      ),
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage('images/person.jpeg'),
          radius: 18,
        ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }

  Column _colorePalete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: titelStyle,
        ),
        const SizedBox(
          height: 8,
        ),
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
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                          ? pinkClr
                          : orangeClr,
                  child: _selectedColor == index
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
}
