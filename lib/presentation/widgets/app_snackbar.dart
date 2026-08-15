import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_new/core/Theme/colors.dart';

/// Centralized snackbar styling.
///
/// Previously, home_page.dart and advancedDrawer.dart each had their own
/// slightly different inline `Get.snackbar(...)` calls for the same events
/// (e.g. "no tasks to delete", "all tasks deleted"). That duplication meant
/// the two places could drift out of sync visually. This class is the single
/// source of truth for that styling.
class AppSnackbar {
  AppSnackbar._();

  static void info(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Get.isDarkMode ? Colors.grey[850] : Colors.white,
      colorText: Get.isDarkMode ? Colors.white : primaryClr,
      icon: const Icon(Icons.info_outline, color: Colors.blueAccent),
    );
  }

  static void success(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Get.isDarkMode ? Colors.grey[850] : Colors.white,
      colorText: Colors.green,
      icon: const Icon(Icons.check_circle_outline, color: Colors.green),
    );
  }

  static void deleted(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Get.isDarkMode ? Colors.grey[850] : Colors.white,
      colorText: primaryClr,
      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
    );
  }

  static void error(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Get.isDarkMode ? Colors.grey[850] : Colors.white,
      colorText: Colors.red,
      icon: const Icon(Icons.error_outline, color: Colors.red),
    );
  }
}
