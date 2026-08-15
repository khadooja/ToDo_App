import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/Theme/colors.dart';
import 'package:flutter/material.dart';
import '../../core/utils/size_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app_new/domain/entities/task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_new/presentation/pages/add_task_page.dart';
import 'package:todo_app_new/presentation/providers/task_providers.dart';


class TaskTile extends ConsumerWidget {
  const TaskTile({super.key, required this.task});

  final Task task;

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dt);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding:
          SizeConfig.orientation == Orientation.landscape
              ? EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(4),
                vertical: getProportionateScreenHeight(4),
              )
              : EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20),
                vertical: getProportionateScreenHeight(10),
              ),
      width:
          SizeConfig.orientation == Orientation.landscape
              ? SizeConfig.screenWidth / 2
              : SizeConfig.screenWidth,
      margin: EdgeInsets.only(bottom: getProportionateScreenHeight(8)),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _getBGClr(task.color),
        ),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            task.title,
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          tooltip: 'Edit task',
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () async {
                            await Get.to(() => AddTaskPage(task: task));
                            ref.read(taskListProvider.notifier).refresh();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey[200],
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${_formatTime(task.startTime)} - ${_formatTime(task.endTime)}',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[100],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      task.note,
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[100],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              width: 0.5,
              color: Colors.grey[200]!.withValues(alpha: 0.7),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                task.isCompleted ? "COMPLETED" : "TODO",
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBGClr(TaskColor color) {
    switch (color) {
      case TaskColor.blue:
        return primaryClr;
      case TaskColor.pink:
        return pinkClr;
      case TaskColor.orange:
        return orangeClr;
    }
  }
}
