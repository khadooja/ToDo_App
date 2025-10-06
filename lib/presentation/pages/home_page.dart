import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo/core/Theme/colors.dart' show darkHeaderClr, primaryClr;
import 'package:todo/core/Theme/text_styles.dart';
import 'package:todo/presentation/controllers/task_controller.dart';
import 'package:todo/data/models/task.dart';
import 'package:todo/core/services/notification_services.dart';
import 'package:todo/presentation/widgets/advancedDrawer.dart';
import 'package:todo/presentation/widgets/cupertino.dart';
import 'add_task_page.dart';
import '../../core/utils/size_config.dart';
import '../widgets/button.dart';
import '../widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NotifyHelper notifyHelper;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    _taskController.getTasks();

    // استدعاء الدوال غير المتزامنة بطريقة صحيحة
    initializeNotifications();
  }

  Future<void> initializeNotifications() async {
    await notifyHelper.initializeNotification();
    //notifyHelper.requestIOSPermissions();
  }

  DateTime _selectedDate = DateTime.now();
  final TaskController _taskController = Get.put(TaskController());
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: _appBar(),
      drawer: AdvancedDrawer(
        notifyHelper: notifyHelper,
        taskController: _taskController,
        notificationsEnabled: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          _addTaskBar(),
          const SizedBox(height: 10),
          _addDateBar(),
          const SizedBox(height: 10),
          _showTasks(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  //old appbar
  /*

  AppBar _appBar() {
    bool isDark = Get.isDarkMode;
    double _rotationAngle = 0;

    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.scaffoldBackgroundColor,
      leading: IconButton(
        onPressed: () {
          ThemeServices().switchTheme();
          notifyHelper.displayNotification(
            title: "Theme Changed",
            body: isDark ? "Activated Light Theme" : "Activated Dark Theme",
          );
        },
        icon: Icon(
          isDark ? Icons.wb_sunny_outlined : Icons.nightlight_round_outlined,
          size: 24,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      actions: [
        StatefulBuilder(
          builder: (context, setState) {
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: _rotationAngle),
              duration: const Duration(milliseconds: 600),
              builder: (context, angle, child) {
                return Transform.rotate(
                  angle: angle,
                  child: IconButton(
                    onPressed: () {
                      setState(() => _rotationAngle += 6.3); 
                      notifyHelper.cancelAllNotification();
                      _taskController.deleteAll(Task());
                      Get.snackbar(
                        "All Tasks Deleted",
                        "You have no tasks",
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 2),
                        backgroundColor:
                            isDark ? Colors.grey[850] : Colors.white,
                        colorText: primaryClr,
                        icon: const Icon(
                          Icons.cleaning_services_outlined,
                          color: Colors.redAccent,
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.cleaning_services_outlined,
                      size: 24,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(width: 10),
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
  */

  AppBar _appBar() {
    bool isDark = Get.isDarkMode;
    double _rotationAngle = 0;

    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.scaffoldBackgroundColor,
      title: Text("My Tasks", style: headingStyle.copyWith(fontSize: 22)),
      leading: Builder(
        builder:
            (context) => IconButton(
              icon: Icon(
                Icons.menu,
                color: isDark ? Colors.white : Colors.black87,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // فتح Drawer
              },
            ),
      ),
      actions: [
        // زر حذف كل المهام مع Animation
        StatefulBuilder(
          builder: (context, setState) {
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: _rotationAngle),
              duration: const Duration(milliseconds: 600),
              builder: (context, angle, child) {
                return Transform.rotate(
                  angle: angle,
                  child: IconButton(
                    onPressed: () async {
                      setState(() => _rotationAngle += 6.3);
                      bool? confirm = await showDeleteAllDialog();
                      if (confirm ?? false) {
                        notifyHelper.cancelAllNotification();
                        _taskController.deleteAll(Task());
                        Get.snackbar(
                          "All Tasks Deleted",
                          "You have no tasks",
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 2),
                          backgroundColor:
                              isDark ? Colors.grey[850] : Colors.white,
                          colorText: primaryClr,
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.redAccent,
                          ),
                        );
                      }
                    },
                    icon: Icon(
                      Icons.delete_outline,
                      size: 24,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subheadingStyle,
              ),
              Text("Today", style: headingStyle),
            ],
          ),
          MyButton(
            label: "+ Add Task",
            onTap: () async {
              await Get.to(() => const AddTaskPage());
              _taskController.getTasks();
            },
          ),
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 6, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (newDate) {
          setState(() {
            _selectedDate = newDate;
          });
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    _taskController.getTasks();
  }

  /* _showTasks() {
    return Expanded(
      child: Obx(() {
        if (_taskController.taskList.isEmpty) {
          return _noTaskMgs();
        }
        else {
          return RefreshIndicator(
          color: primaryClr,
          onRefresh: () => _onRefresh(),
          child: ListView.builder(
            scrollDirection:
                SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
            itemCount: _taskController.taskList.length,
            itemBuilder: (BuildContext context, int index) {
              var task = _taskController.taskList[index];
              DateTime? taskDate;
              try {
                taskDate =
                    task.date != null
                        ? DateFormat.yMd().parse(task.date!)
                        : null;
              } catch (e) {
                print("Invalid date format: ${task.date}");
              }

              bool showTask = false;

              if (task.repeat == 'Daily') {
                showTask = true;
              } else if (taskDate != null) {
                if (task.repeat == 'Yearly' &&
                    taskDate.day == _selectedDate.day &&
                    taskDate.month == _selectedDate.month) {
                  showTask = true;
                } else if (task.repeat == 'Monthly' &&
                    taskDate.day == _selectedDate.day) {
                  showTask = true;
                } else if (task.repeat == 'Weekly' &&
                    _selectedDate.difference(taskDate).inDays % 7 == 0) {
                  showTask = true;
                } else if (task.date ==
                    DateFormat.yMd().format(_selectedDate)) {
                  showTask = true;
                }
              }

              if (!showTask) return Container();

              // تحويل الوقت بشكل آمن
              DateTime? taskTime;
              try {
                taskTime = DateFormat.jm().parse(task.startTime!);
              } catch (e) {
                print("Invalid time format: ${task.startTime}");
                return Container(); // تجاهل المهمة لو الوقت غير صالح
              }

              var myTime = DateFormat("HH:mm").format(taskTime);

              notifyHelper.scheduledNotification(
                int.parse(myTime.split(":")[0]),
                int.parse(myTime.split(":")[1]),
                task,
              );

              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 1375),
                child: SlideAnimation(
                  horizontalOffset: 300,
                  child: FadeInAnimation(
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.fastLinearToSlowEaseIn,
                    child: GestureDetector(
                      onTap: () => _showBottomSheet(context, task),
                      child: TaskTile(task: task),
                    ),
                  ),
                ),
              );
            },
          ),
        );
        }
      }),
    );
  }
 */
  _showTasks() {
    return Expanded(
      child: Obx(() {
        if (_taskController.taskList.isEmpty) {
          return _noTaskMgs();
        } else {
          return RefreshIndicator(
            color: primaryClr,
            onRefresh: () => _onRefresh(),
            child: ListView.builder(
              scrollDirection:
                  SizeConfig.orientation == Orientation.landscape
                      ? Axis.horizontal
                      : Axis.vertical,
              itemCount: _taskController.taskList.length,
              itemBuilder: (BuildContext context, int index) {
                var task = _taskController.taskList[index];

                // تحويل التاريخ بشكل آمن
                DateTime? taskDate;
                try {
                  taskDate =
                      task.date != null
                          ? DateFormat.yMd().parse(task.date!)
                          : null;
                } catch (e) {
                  print("Invalid date format: ${task.date}");
                }

                bool showTask = false;

                if (task.repeat == 'Daily') {
                  showTask = true;
                } else if (taskDate != null) {
                  if (task.repeat == 'Yearly' &&
                      taskDate.day == _selectedDate.day &&
                      taskDate.month == _selectedDate.month) {
                    showTask = true;
                  } else if (task.repeat == 'Monthly' &&
                      taskDate.day == _selectedDate.day) {
                    showTask = true;
                  } else if (task.repeat == 'Weekly' &&
                      _selectedDate.difference(taskDate).inDays % 7 == 0) {
                    showTask = true;
                  } else if (task.date ==
                      DateFormat.yMd().format(_selectedDate)) {
                    showTask = true;
                  }
                }

                if (!showTask) return Container();

                // تحويل الوقت بشكل آمن (صيغ متعددة)
                DateTime? taskTime;
                try {
                  taskTime = DateFormat("HH:mm").parse(task.startTime!);
                } catch (e1) {
                  try {
                    taskTime = DateFormat.jm().parse(task.startTime!);
                  } catch (e2) {
                    print("Invalid time format: ${task.startTime}");
                    taskTime = null; // بدل تجاهل المهمة
                  }
                }

                if (taskTime == null)
                  taskTime = DateTime.now(); // احتياطي لتجنب crash

                var myTime = DateFormat("HH:mm").format(taskTime);

                notifyHelper.scheduledNotification(
                  int.parse(myTime.split(":")[0]),
                  int.parse(myTime.split(":")[1]),
                  task,
                );

                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 1375),
                  child: SlideAnimation(
                    horizontalOffset: 300,
                    child: FadeInAnimation(
                      duration: const Duration(milliseconds: 1500),
                      curve: Curves.fastLinearToSlowEaseIn,
                      child: GestureDetector(
                        onTap: () => _showBottomSheet(context, task),
                        child: TaskTile(task: task),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      }),
    );
  }

  _noTaskMgs() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 2000),
          child: RefreshIndicator(
            color: primaryClr,
            onRefresh: () => _onRefresh(),
            child: SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.center,
                direction:
                    SizeConfig.orientation == Orientation.landscape
                        ? Axis.horizontal
                        : Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(height: 6)
                      : const SizedBox(height: 220),
                  Image.asset(
                    "assets/images/undraw_to-do-list_eoia.png",
                    height: 140,
                    width: 140,
                    //color: primaryClr,
                    //semanticsLabel: "Tasks",
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 10.0,
                    ),
                    child: Text(
                      " You don't have any tasks yet!\nTap on the + button to add a new task",
                      style: subtitelStyle,
                      //overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(height: 120)
                      : const SizedBox(height: 180),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildBottomSheet({
    required String label,
    required Function() onTap,
    required Color clr,
    bool isClose = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color:
                isClose == true
                    ? Get.isDarkMode
                        ? Colors.grey[600]!
                        : Colors.grey[300]!
                    : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color:
              isClose == true
                  ? Get.isDarkMode
                      ? Colors.grey[600]!
                      : Colors.grey[300]!
                  : clr,
        ),
        child: Center(
          child: Text(
            label,
            style:
                isClose ? titelStyle : titelStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 4),
          width: SizeConfig.screenWidth,
          height:
              (SizeConfig.orientation == Orientation.landscape)
                  ? (task.isCompleted == 1)
                      ? SizeConfig.screenHeight * 0.6
                      : SizeConfig.screenHeight * 0.8
                  : (task.isCompleted == 1)
                  ? SizeConfig.screenHeight * 0.30
                  : SizeConfig.screenHeight * 0.39,
          color: Get.isDarkMode ? darkHeaderClr : Colors.white,
          child: Column(
            children: [
              Flexible(
                child: Container(
                  height: 6,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
                  ),
                ),
              ),
              const Spacer(),
              task.isCompleted == 1
                  ? Container()
                  : _buildBottomSheet(
                    label: "Task Completed",
                    onTap: () {
                      notifyHelper.cancelNotification(task);
                      _taskController.markTaskCompleted(task.id!);
                      Get.back();
                    },
                    clr: primaryClr,
                  ),
              _buildBottomSheet(
                label: "Delete Task",
                onTap: () {
                  notifyHelper.cancelNotification(task);
                  _taskController.delete(task);

                  Get.back();
                },
                clr: Colors.red,
              ),
              Divider(
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
              ),
              _buildBottomSheet(
                label: "Close",
                onTap: () {
                  Get.back();
                },
                clr: Colors.white,
                isClose: true,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
