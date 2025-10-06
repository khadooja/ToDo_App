import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool?> showDeleteAllDialog() {
  return showDialog<bool>(
    context: Get.context!,
    barrierDismissible: true,
    builder: (context) {
      bool isDark = Get.isDarkMode;

      if (Theme.of(context).platform == TargetPlatform.iOS) {
        return CupertinoAlertDialog(
          title: const Text("Delete All Tasks"),
          content: const Text("Are you sure you want to delete all tasks?"),
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
          title: const Text("Delete All Tasks"),
          content: const Text("Are you sure you want to delete all tasks?"),
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
