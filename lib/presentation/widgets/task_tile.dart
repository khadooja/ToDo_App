import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_new/core/Theme/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_new/domain/entities/task.dart';
import 'package:todo_app_new/core/Theme/text_styles.dart';
import 'package:todo_app_new/core/Theme/app_spacing.dart';
import 'package:todo_app_new/presentation/pages/add_task_page.dart';
import 'package:todo_app_new/presentation/providers/task_providers.dart';
 
/// A single task card.
///
/// UI/UX polish pass: the previous version filled the whole card with a
/// saturated flat color (blue/pink/orange), which read as a generic
/// CRUD-list item rather than a considered product. This version uses a
/// neutral surface with a colored accent bar — still driven by the task's
/// existing `color` field, no new data — a tap-to-complete affordance, and
/// a small repeat badge when the task recurs (`RepeatType` already
/// existed; it just wasn't surfaced on the card before).
class TaskTile extends ConsumerWidget {
  const TaskTile({super.key, required this.task});
 
  final Task task;
 
  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dt);
  }
 
  Color _accentColor(TaskColor color) {
    switch (color) {
      case TaskColor.blue:
        return primaryClr;
      case TaskColor.pink:
        return pinkClr;
      case TaskColor.orange:
        return orangeClr;
    }
  }
 
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Get.isDarkMode;
    final accent = _accentColor(task.color);
    final surface = isDark ? const Color(0xFF1E1E22) : Colors.white;
 
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 5, color: accent),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.sm,
                    AppSpacing.xxs,
                    AppSpacing.sm,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _CompletionCheckbox(task: task, accent: accent, ref: ref),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 250),
                              style: titelStyle.copyWith(
                                fontSize: 16,
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                color: task.isCompleted
                                    ? (isDark ? Colors.grey[500] : Colors.grey[400])
                                    : (isDark ? Colors.white : Colors.black87),
                              ),
                              child: Text(
                                task.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Edit task',
                            visualDensity: VisualDensity.compact,
                            icon: Icon(
                              Icons.edit_outlined,
                              size: 18,
                              color: isDark ? Colors.grey[400] : Colors.grey[500],
                            ),
                            onPressed: () async {
                              await Get.to(() => AddTaskPage(task: task));
                              ref.read(taskListProvider.notifier).refresh();
                            },
                          ),
                        ],
                      ),
                      if (task.note.trim().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 32, top: 2),
                          child: Text(
                            task.note,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: bodyStyle.copyWith(
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(left: 32, top: AppSpacing.xs),
                        child: Wrap(
                          spacing: AppSpacing.xs,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            _MetaChip(
                              icon: Icons.access_time_rounded,
                              label:
                                  '${_formatTime(task.startTime)} - ${_formatTime(task.endTime)}',
                              isDark: isDark,
                            ),
                            if (task.repeat != RepeatType.none)
                              _MetaChip(
                                icon: Icons.repeat_rounded,
                                label: task.repeat.label,
                                isDark: isDark,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 
/// Tap-to-complete checkbox. Only marks a task complete — the repository
/// layer has no "uncomplete" operation (by design, unchanged in this UI
/// pass), so this intentionally does nothing once a task is already
/// completed rather than pretending to support a toggle that doesn't exist.
class _CompletionCheckbox extends StatelessWidget {
  const _CompletionCheckbox({
    required this.task,
    required this.accent,
    required this.ref,
  });
 
  final Task task;
  final Color accent;
  final WidgetRef ref;
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: task.isCompleted
          ? null
          : () => ref.read(taskListProvider.notifier).markCompleted(task.id!),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(top: 2),
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: task.isCompleted ? accent : Colors.transparent,
          border: Border.all(color: accent, width: 2),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: task.isCompleted
              ? const Icon(Icons.check, size: 14, color: Colors.white, key: ValueKey('done'))
              : const SizedBox.shrink(key: ValueKey('todo')),
        ),
      ),
    );
  }
}
 
class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label, required this.isDark});
 
  final IconData icon;
  final String label;
  final bool isDark;
 
  @override
  Widget build(BuildContext context) {
    final color = isDark ? Colors.grey[400] : Colors.grey[600];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 3),
        Text(label, style: captionStyle.copyWith(color: color)),
      ],
    );
  }
}
 