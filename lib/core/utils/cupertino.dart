import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool?> _showConfirmDialog({
  required String title,
  required String message,
}) {
  return showDialog<bool>(
    context: Get.context!,
    barrierDismissible: true,
    builder: (context) {
      bool isDark = Get.isDarkMode;

      if (Theme.of(context).platform == TargetPlatform.iOS) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text("Delete"),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      } else {
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      }
    },
  );
}

Future<bool?> showDeleteAllDialog() {
  return _showConfirmDialog(
    title: "Delete All Tasks",
    message: "Are you sure you want to delete all tasks?",
  );
}

/// New in Phase 3: deleting a single task used to happen instantly with no
/// confirmation at all, inconsistent with "Delete All" which always asked
/// first. This reuses the exact same dialog shell.
Future<bool?> showDeleteTaskDialog() {
  return _showConfirmDialog(
    title: "Delete Task",
    message: "Are you sure you want to delete this task?",
  );
}
