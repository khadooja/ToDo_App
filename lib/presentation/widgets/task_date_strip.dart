import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:todo_app_new/core/Theme/colors.dart';
import 'package:todo_app_new/core/Theme/text_styles.dart';
import 'package:todo_app_new/core/Theme/app_spacing.dart';

/// Date navigation for the home screen: a horizontal quick-pick strip for
/// nearby days, plus a "Month Year" header that opens a full Material
/// calendar (any date, any year — not limited to the strip's window or to
/// dates that already have tasks). Opens via the calendar icon button or by
/// double-tapping the header row.
class TaskDateStrip extends StatelessWidget {
  const TaskDateStrip({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  Future<void> _openFullCalendar(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      // Wide range so the calendar isn't artificially limited to "existing
      // task" dates — users can pick any year, including years far in the
      // future or past, exactly as requested.
      firstDate: DateTime(2015),
      lastDate: DateTime(2121),
      helpText: 'Select a date',
    );
    if (picked != null) onDateChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    // Anchor the strip a few days before the selected date rather than
    // always at "today" — otherwise jumping to a distant date via the full
    // calendar would leave the strip showing an unrelated window.
    final stripStart = selectedDate.subtract(const Duration(days: 3));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onDoubleTap: () => _openFullCalendar(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat.yMMMM().format(selectedDate), style: titleStyle),
                IconButton(
                  tooltip: 'Open calendar',
                  onPressed: () => _openFullCalendar(context),
                  icon: Icon(
                    Icons.calendar_month_rounded,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 84,
          child: DatePicker(
            // A fresh key forces the strip to fully re-initialize (and
            // therefore re-center) whenever the selected date jumps to
            // somewhere outside its current scroll window — e.g. after
            // picking a date via the full calendar. Without this, the
            // package's internal state (set once in its own initState)
            // would silently ignore the new initialSelectedDate.
            key: ValueKey(selectedDate),
            stripStart,
            initialSelectedDate: selectedDate,
            height: 84,
            width: 64,
            selectionColor: primaryClr,
            selectedTextColor: Colors.white,
            dateTextStyle: GoogleFonts.lato(
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.grey,
              ),
            ),
            dayTextStyle: GoogleFonts.lato(
              textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            monthTextStyle: GoogleFonts.lato(
              textStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            onDateChange: onDateChanged,
          ),
        ),
      ],
    );
  }
}
