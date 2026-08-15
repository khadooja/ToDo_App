import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_new/core/Theme/colors.dart';
import 'package:todo_app_new/core/Theme/text_styles.dart';
import 'package:todo_app_new/core/Theme/app_spacing.dart';

/// Animated empty-state illustration + message, reusable anywhere a list
/// can be empty. Optionally shows a call-to-action button (e.g. "Add Task"
/// when there are genuinely zero tasks — no point offering it for "no
/// tasks on this specific date", since the user already knows how to add
/// one via the FAB).
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    this.assetPath = "assets/images/undraw_to-do-list_eoia.png",
    this.onAction,
    this.actionLabel,
  });

  final String title;
  final String subtitle;
  final String assetPath;
  final VoidCallback? onAction;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, (1 - value) * 16),
              child: child,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(assetPath, height: 130),
              const SizedBox(height: AppSpacing.lg),
              Text(title, style: titelStyle, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                subtitle,
                style: bodyStyle.copyWith(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              if (onAction != null) ...[
                const SizedBox(height: AppSpacing.lg),
                FilledButton.icon(
                  onPressed: onAction,
                  icon: const Icon(Icons.add),
                  label: Text(actionLabel ?? "Add Task"),
                  style: FilledButton.styleFrom(
                    backgroundColor: primaryClr,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
