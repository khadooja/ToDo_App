import 'add_task_page.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../widgets/task_tile.dart';
import '../widgets/empty_state.dart';
import '../widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import '../widgets/section_header.dart';
import '../widgets/task_date_strip.dart';
import '../../core/utils/size_config.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_app_new/core/Theme/colors.dart';
import 'package:todo_app_new/core/utils/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_new/domain/entities/task.dart';
import 'package:todo_app_new/core/Theme/text_styles.dart';
import 'package:todo_app_new/core/Theme/app_spacing.dart';
import 'package:todo_app_new/l10n/app_localizations.dart';
import 'package:todo_app_new/core/services/notification_services.dart';
import 'package:todo_app_new/presentation/widgets/advancedDrawer.dart';
import 'package:todo_app_new/presentation/providers/task_providers.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late NotifyHelper notifyHelper;
  final _box = GetStorage();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    initializeNotifications();
  }

  Future<void> initializeNotifications() async {
    await notifyHelper.initializeNotification();
  }

  // --- Everything below this point through _matchesSelectedDate is
  // unchanged business logic, carried over as-is from before this UI pass.

  void _scheduleNotifications(List<Task> tasks) {
    bool notificationsEnabled = _box.read<bool>('notificationsEnabled') ?? true;
    if (!notificationsEnabled) return;
    for (final task in tasks) {
      notifyHelper.scheduledNotification(task);
    }
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _matchesSelectedDate(Task task) {
    switch (task.repeat) {
      case RepeatType.daily:
        return true;
      case RepeatType.yearly:
        return task.date.day == _selectedDate.day &&
            task.date.month == _selectedDate.month;
      case RepeatType.monthly:
        return task.date.day == _selectedDate.day;
      case RepeatType.weekly:
        return _selectedDate.difference(task.date).inDays % 7 == 0;
      case RepeatType.none:
        return _isSameDay(task.date, _selectedDate);
    }
  }

  String _greeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.greetingMorning;
    if (hour < 17) return l10n.greetingAfternoon;
    return l10n.greetingEvening;
  }

  /// Pure UI grouping — does not change how tasks are stored, filtered, or
  /// scheduled. A task's start-time hour decides which bucket it falls in.
  String _bucketLabel(Task task, AppLocalizations l10n) {
    final hour = task.startTime.hour;
    if (hour < 12) return l10n.sectionMorning;
    if (hour < 17) return l10n.sectionAfternoon;
    return l10n.sectionEvening;
  }

  Future<void> _goAddTask() async {
    await Get.to(() => const AddTaskPage());
    ref.read(taskListProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = Get.isDarkMode;

    // Schedule (or reschedule) notifications whenever the task list
    // changes — unchanged from before this UI pass.
    ref.listen<AsyncValue<List<Task>>>(taskListProvider, (previous, next) {
      next.whenData(_scheduleNotifications);
    });

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: _appBar(l10n, isDark),
      drawer: AdvancedDrawer(notifyHelper: notifyHelper),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goAddTask,
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
      body: Column(
        children: [
          _header(l10n, isDark),
          const SizedBox(height: AppSpacing.xs),
          TaskDateStrip(
            selectedDate: _selectedDate,
            onDateChanged: (date) => setState(() => _selectedDate = date),
          ),
          const SizedBox(height: AppSpacing.xs),
          _showTasks(l10n),
        ],
      ),
    );
  }

  AppBar _appBar(AppLocalizations l10n, bool isDark) {
    double rotationAngle = 0;

    return AppBar(
      title: Text(
        l10n.myTasks,
        style: headingStyle.copyWith(fontSize: 22, fontWeight: FontWeight.w800),
      ),
      leading: Builder(
        builder: (context) => IconButton(
          tooltip: 'Open menu',
          icon: Icon(
            Icons.menu_rounded,
            color: isDark ? Colors.white : Colors.black87,
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      actions: [
        StatefulBuilder(
          builder: (context, setState) {
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: rotationAngle),
              duration: const Duration(milliseconds: 600),
              builder: (context, angle, child) {
                return Transform.rotate(
                  angle: angle,
                  child: IconButton(
                    tooltip: 'Delete all tasks',
                    onPressed: () async {
                      final tasks = ref.read(taskListProvider).value ?? [];
                      if (tasks.isEmpty) {
                        AppSnackbar.info(
                          "No Tasks",
                          "There are no tasks to delete",
                        );
                        return;
                      }

                      setState(() => rotationAngle += 6.3);

                      bool? confirm = await showDeleteAllDialog();
                      if (confirm ?? false) {
                        notifyHelper.cancelAllNotification();
                        await ref.read(taskListProvider.notifier).deleteAll();

                        AppSnackbar.deleted(
                          "All Tasks Deleted",
                          "You have no tasks now",
                        );
                      }
                    },
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      size: 24,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(width: AppSpacing.xs),
      ],
    );
  }

  /// New: greeting + full selected-date label + a live task-count badge.
  /// Replaces the old static "Today" header, which carried no real
  /// information (it always said "Today" regardless of what date was
  /// actually selected in the strip).
  Widget _header(AppLocalizations l10n, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xs,
        AppSpacing.lg,
        0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_greeting(l10n), style: greetingStyle),
                const SizedBox(height: 2),
                Text(
                  DateFormat.yMMMMEEEEd().format(_selectedDate),
                  style: titleStyle.copyWith(fontSize: 19),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Consumer(
            builder: (context, ref, _) {
              final asyncTasks = ref.watch(taskListProvider);
              final count =
                  asyncTasks.value?.where(_matchesSelectedDate).length ?? 0;
              return Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: primaryClr.withOpacity(isDark ? 0.22 : 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  l10n.taskCountLabel(count),
                  style: captionStyle.copyWith(
                    color: primaryClr,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _showTasks(AppLocalizations l10n) {
    return Expanded(
      child: Consumer(
        builder: (context, ref, _) {
          final asyncTasks = ref.watch(taskListProvider);
          return asyncTasks.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => _errorState(),
            data: (allTasks) {
              if (allTasks.isEmpty) {
                return _wrapRefresh(
                  EmptyState(
                    title: l10n.noTasksYetTitle,
                    subtitle: l10n.noTasksYetSubtitle,
                    onAction: _goAddTask,
                  ),
                  fillHeight: true,
                );
              }

              final visibleTasks = allTasks.where(_matchesSelectedDate).toList()
                ..sort((a, b) {
                  final aMinutes = a.startTime.hour * 60 + a.startTime.minute;
                  final bMinutes = b.startTime.hour * 60 + b.startTime.minute;
                  return aMinutes.compareTo(bMinutes);
                });

              if (visibleTasks.isEmpty) {
                return _wrapRefresh(
                  EmptyState(
                    title: l10n.noTasksForDateTitle,
                    subtitle: l10n.noTasksForDateSubtitle,
                  ),
                  fillHeight: true,
                );
              }

              // Group into Morning / Afternoon / Evening, preserving
              // chronological order within each bucket.
              final buckets = <String, List<Task>>{};
              for (final task in visibleTasks) {
                buckets
                    .putIfAbsent(_bucketLabel(task, l10n), () => [])
                    .add(task);
              }

              final tiles = <Widget>[];
              int animationIndex = 0;
              for (final entry in buckets.entries) {
                tiles.add(SectionHeader(title: entry.key));
                for (final task in entry.value) {
                  final position = animationIndex++;
                  tiles.add(
                    AnimationConfiguration.staggeredList(
                      position: position,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 24,
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () => _showBottomSheet(context, task),
                            onDoubleTap: () async {
                              await Get.to(() => AddTaskPage(task: task));
                              ref.read(taskListProvider.notifier).refresh();
                            },
                            child: TaskTile(task: task),
                          ),
                        ),
                      ),
                    ),
                  );
                }
              }
              // Clearance so the last card isn't hidden behind the FAB.
              tiles.add(const SizedBox(height: 90));

              return _wrapRefresh(
                AnimationLimiter(child: Column(children: tiles)),
              );
            },
          );
        },
      ),
    );
  }

  Widget _wrapRefresh(Widget content, {bool fillHeight = false}) {
    return RefreshIndicator(
      color: primaryClr,
      onRefresh: () => ref.read(taskListProvider.notifier).refresh(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          fillHeight
              ? SizedBox(height: SizeConfig.screenHeight * 0.65, child: content)
              : content,
        ],
      ),
    );
  }

  Widget _errorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 12),
            Text(
              "Something went wrong loading your tasks.",
              style: subtitelStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => ref.read(taskListProvider.notifier).refresh(),
              child: const Text("Try again"),
            ),
          ],
        ),
      ),
    );
  }

  // --- Bottom sheet: unchanged logic, only the outer container gained
  // rounded top corners to match the new card language.

  Widget _buildBottomSheet({
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
            color: isClose == true
                ? Get.isDarkMode
                      ? Colors.grey[600]!
                      : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true
              ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
              : clr,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? titelStyle
                : titelStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 4),
          width: SizeConfig.screenWidth,
          height: (SizeConfig.orientation == Orientation.landscape)
              ? (task.isCompleted)
                    ? SizeConfig.screenHeight * 0.6
                    : SizeConfig.screenHeight * 0.8
              : (task.isCompleted)
              ? SizeConfig.screenHeight * 0.30
              : SizeConfig.screenHeight * 0.39,
          decoration: BoxDecoration(
            color: Get.isDarkMode ? darkHeaderClr : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppRadius.lg),
              topRight: Radius.circular(AppRadius.lg),
            ),
          ),
          child: Column(
            children: [
              Flexible(
                child: Container(
                  height: 6,
                  width: 120,
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
                  ),
                ),
              ),
              const Spacer(),
              task.isCompleted
                  ? Container()
                  : _buildBottomSheet(
                      label: "Edit Task",
                      onTap: () async {
                        Get.back();
                        await Get.to(() => AddTaskPage(task: task));
                        ref.read(taskListProvider.notifier).refresh();
                      },
                      clr: Colors.orangeAccent,
                    ),

              task.isCompleted
                  ? Container()
                  : _buildBottomSheet(
                      label: "Task Completed",
                      onTap: () {
                        notifyHelper.cancelNotification(task);
                        ref
                            .read(taskListProvider.notifier)
                            .markCompleted(task.id!);
                        Get.back();
                      },
                      clr: primaryClr,
                    ),
              _buildBottomSheet(
                label: "Delete Task",
                onTap: () async {
                  Get.back();
                  bool? confirm = await showDeleteTaskDialog();
                  if (confirm ?? false) {
                    notifyHelper.cancelNotification(task);
                    ref.read(taskListProvider.notifier).deleteTask(task);
                  }
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
