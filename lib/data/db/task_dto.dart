import 'package:flutter/material.dart';
import 'package:todo_app_new/domain/entities/task.dart';

/// Data Transfer Object: the shape a Task takes in SQLite. Keeping this
/// separate from the domain Task means the domain/presentation layers never
/// need to know about storage encodings (column names, string formats).
///
/// BUG FIX carried over from the old code: dates used to be stored via
/// `DateFormat.yMd()` (locale-dependent, e.g. "8/14/2026") and times via a
/// pre-formatted 12-hour string from `TimeOfDay.format(context)`. Reading
/// them back required trying multiple parse formats and silently falling
/// back to "now" on failure (see the old home_page.dart / notification
/// scheduling code). Storage is now ISO 'yyyy-MM-dd' and 24h 'HH:mm', both
/// unambiguous and locale-independent.
class TaskDto {
  static Map<String, dynamic> toMap(Task task) {
    return {
      'id': task.id,
      'title': task.title,
      'note': task.note,
      'isCompleted': task.isCompleted ? 1 : 0,
      'date': _dateToIso(task.date),
      'startTime': _timeToIso(task.startTime),
      'endTime': _timeToIso(task.endTime),
      'color': task.color.index,
      'remind': task.remind,
      'repeat': task.repeat.label,
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      title: (map['title'] as String?) ?? '',
      note: (map['note'] as String?) ?? '',
      isCompleted: (map['isCompleted'] as int?) == 1,
      date: _dateFromIso(map['date'] as String?),
      startTime: _timeFromIso(map['startTime'] as String?),
      endTime: _timeFromIso(map['endTime'] as String?),
      color: _colorFromIndex(map['color'] as int?),
      remind: (map['remind'] as int?) ?? 5,
      repeat: RepeatTypeX.fromLabel((map['repeat'] as String?) ?? 'None'),
    );
  }

  static TaskColor _colorFromIndex(int? index) {
    if (index == null || index < 0 || index >= TaskColor.values.length) {
      return TaskColor.blue;
    }
    return TaskColor.values[index];
  }

  static String _dateToIso(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  static DateTime _dateFromIso(String? iso) {
    if (iso == null || iso.isEmpty) return DateTime.now();
    final parts = iso.split('-');
    if (parts.length != 3) return DateTime.now();
    return DateTime(
      int.tryParse(parts[0]) ?? DateTime.now().year,
      int.tryParse(parts[1]) ?? 1,
      int.tryParse(parts[2]) ?? 1,
    );
  }

  static String _timeToIso(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  static TimeOfDay _timeFromIso(String? iso) {
    if (iso == null || !iso.contains(':')) {
      return const TimeOfDay(hour: 9, minute: 0);
    }
    final parts = iso.split(':');
    return TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 9,
      minute: int.tryParse(parts[1]) ?? 0,
    );
  }
}
