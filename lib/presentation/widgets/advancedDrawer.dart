import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/core/Theme/colors.dart';
import 'package:todo/core/Theme/text_styles.dart';
import 'package:todo/presentation/controllers/task_controller.dart';
import 'package:todo/data/models/task.dart';
import 'package:todo/core/services/notification_services.dart';
import 'package:todo/core/services/theme_services.dart';

class AdvancedDrawer extends StatefulWidget {
  final NotifyHelper notifyHelper;
  final TaskController taskController;
  final bool notificationsEnabled;

  const AdvancedDrawer({
    super.key,
    required this.notifyHelper,
    required this.taskController,
    required this.notificationsEnabled,
  });

  @override
  State<AdvancedDrawer> createState() => _AdvancedDrawerState();
}

class _AdvancedDrawerState extends State<AdvancedDrawer> {
   bool _notificationsEnabled=false;

  @override
  void initState() {
    super.initState();
    _initNotificationState();
  }

  void _initNotificationState() async {
    bool isAllowed = await widget.notifyHelper.checkNotificationPermission();
    setState(() {
      _notificationsEnabled = isAllowed;
    });
  }

  bool isDark = Get.isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                Get.isDarkMode
                    ? [Colors.grey[900]!, Colors.grey[850]!]
                    : [Colors.white, Colors.grey[100]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildHeader(),
            const SizedBox(height: 10),
            _advancedDrawerItem(
              icon: Get.isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
              title: "Dark Mode",
              isSwitch: true,
              value: Get.isDarkMode,
              tooltip: "Switch between Light and Dark mode",
              onChanged: (val) => ThemeServices().switchTheme(),
            ),
            _advancedDrawerItem(
              icon: Icons.delete_outline,
              title: "Delete All Tasks",
              isSwitch: false,
              tooltip: "Remove all tasks permanently",
              onTap: () async {
                // تحقق إذا كانت هناك مهام
                if (widget.taskController.taskList.isEmpty) {
                  Get.snackbar(
                    "No Tasks",
                    "There are no tasks to delete",
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 2),
                    backgroundColor:
                        Get.isDarkMode ? Colors.grey[850] : Colors.white,
                    colorText: isDark ? Colors.white : primaryClr,
                    icon: const Icon(
                      Icons.info_outline,
                      color: Colors.blueAccent,
                    ),
                  );
                  return;
                }

                // طلب التأكيد للحذف
                bool confirm =
                    await Get.dialog<bool>(
                      AlertDialog(
                        title: const Text("Delete All Tasks"),
                        content: const Text(
                          "Are you sure you want to delete all tasks?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(result: false),
                            child: const Text("No"),
                          ),
                          TextButton(
                            onPressed: () => Get.back(result: true),
                            child: const Text("Yes"),
                          ),
                        ],
                      ),
                    ) ??
                    false;

                if (confirm) {
                  widget.notifyHelper.cancelAllNotification();
                  widget.taskController.deleteAll();
                  widget.taskController.getTasks(); 

                  Get.snackbar(
                    "All Tasks Deleted",
                    "You have no tasks now",
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 2),
                    backgroundColor:
                        Get.isDarkMode ? Colors.grey[850] : Colors.white,
                    colorText: primaryClr,
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                    ),
                  );
                }
              },
            ),
            _advancedDrawerItem(
              icon: Icons.notifications,
              title: "Notifications",
              isSwitch: true,
              value: _notificationsEnabled,
              tooltip: "Enable/Disable task notifications",
              onChanged: (val) async {
                setState(() => _notificationsEnabled = val);
                if (val) {
                  widget.notifyHelper.displayNotification(
                    title: "Todo App",
                    body: "Notifications Enabled",
                  );
                } else {
                  widget.notifyHelper.cancelAllNotification();
                  widget.notifyHelper.displayNotification(
                    title: "Todo App",
                    body: "Notifications Disabled",
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  DrawerHeader _buildHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryClr.withOpacity(0.8), primaryClr],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(40)),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          "Todo Options",
          style: headingStyle.copyWith(color: Colors.white, fontSize: 22),
        ),
      ),
    );
  }

  Widget _advancedDrawerItem({
    required IconData icon,
    required String title,
    bool isSwitch = false,
    bool value = false,
    String? tooltip,
    Function(bool)? onChanged,
    Function()? onTap,
  }) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween(begin: const Offset(-0.5, 0), end: const Offset(0, 0)),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      builder: (context, offset, child) {
        return Transform.translate(
          offset: offset * 100,
          child: Opacity(opacity: 1.0, child: child),
        );
      },
      child: Tooltip(
        message: tooltip ?? "",
        waitDuration: const Duration(milliseconds: 500),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: primaryClr.withOpacity(0.3),
            highlightColor: primaryClr.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(icon, color: primaryClr, size: 28),
                      const SizedBox(width: 15),
                      Text(title, style: titelStyle.copyWith(fontSize: 18)),
                    ],
                  ),
                  isSwitch
                      ? Switch(
                        value: value,
                        activeColor: primaryClr,
                        onChanged: onChanged,
                      )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
