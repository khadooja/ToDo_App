import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_app_new/core/Theme/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_new/core/Theme/text_styles.dart';
import 'package:todo_app_new/core/services/theme_services.dart';
import 'package:todo_app_new/presentation/widgets/cupertino.dart';
import 'package:todo_app_new/presentation/widgets/app_snackbar.dart';
import 'package:todo_app_new/core/services/notification_services.dart';
import 'package:todo_app_new/presentation/providers/task_providers.dart';

class AdvancedDrawer extends ConsumerStatefulWidget {
  final NotifyHelper notifyHelper;

  // NOTE: taskController is no longer accepted here — home_page.dart used
  // to pass its GetX TaskController instance in; this widget now reads
  // taskListProvider directly via `ref`, so there's nothing to pass in.
  const AdvancedDrawer({super.key, required this.notifyHelper});

  @override
  ConsumerState<AdvancedDrawer> createState() => _AdvancedDrawerState();
}

class _AdvancedDrawerState extends ConsumerState<AdvancedDrawer> {
  bool _notificationsEnabled = true;
  final _box = GetStorage();

  @override
  void initState() {
    super.initState();
    _initNotificationState();
  }

  void _initNotificationState() async {
    bool storedPreference = _box.read<bool>('notificationsEnabled') ?? true;
    bool systemAllowed = await widget.notifyHelper
        .checkNotificationPermission();
    setState(() {
      _notificationsEnabled = storedPreference && systemAllowed;
    });
  }

  bool isDark = Get.isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: Get.isDarkMode
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
                final tasks = ref.read(taskListProvider).value ?? [];
                if (tasks.isEmpty) {
                  AppSnackbar.info("No Tasks", "There are no tasks to delete");
                  return;
                }

                bool confirm = await showDeleteAllDialog() ?? false;

                if (confirm) {
                  widget.notifyHelper.cancelAllNotification();
                  await ref.read(taskListProvider.notifier).deleteAll();

                  AppSnackbar.deleted(
                    "All Tasks Deleted",
                    "You have no tasks now",
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
                _box.write('notificationsEnabled', val);
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
          // ignore: deprecated_member_use
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
            // ignore: deprecated_member_use
            splashColor: primaryClr.withOpacity(0.3),
            // ignore: deprecated_member_use
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
                          // ignore: deprecated_member_use
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
