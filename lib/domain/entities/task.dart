import 'package:flutter/material.dart';

/// How often a task recurs.
///
/// Replaces the old raw `String repeat` field ('Daily', 'Weekly', ...),
/// which was error-prone (typos wouldn't be caught by the compiler) and let
/// invalid values silently fall through every switch statement that used it.
enum RepeatType { none, daily, weekly, monthly, yearly }

extension RepeatTypeX on RepeatType {
  /// Human-readable label, also used as the storage value in SQLite so
  /// existing rows written by the old String-based schema stay readable.
  String get label {
    switch (this) {
      case RepeatType.none:
        return 'None';
      case RepeatType.daily:
        return 'Daily';
      case RepeatType.weekly:
        return 'Weekly';
      case RepeatType.monthly:
        return 'Monthly';
      case RepeatType.yearly:
        return 'Yearly';
    }
  }

  static RepeatType fromLabel(String label) {
    return RepeatType.values.firstWhere(
      (r) => r.label == label,
      orElse: () => RepeatType.none,
    );
  }
}

/// Task accent color.
///
/// Replaces the old raw `int color` (0/1/2), which had to be kept in sync
/// by hand with a hardcoded switch statement in task_tile.dart — nothing
/// stopped the two from drifting apart.
enum TaskColor { blue, pink, orange }

class Task {
  final int? id;
  final String title;
  final String note;
  final bool isCompleted;
  final DateTime date; // date-only; time-of-day component is ignored
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final TaskColor color;
  final int remind; // minutes early
  final RepeatType repeat;

  const Task({
    this.id,
    required this.title,
    required this.note,
    this.isCompleted = false,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.color = TaskColor.blue,
    this.remind = 5,
    this.repeat = RepeatType.none,
  });

  Task copyWith({
    int? id,
    String? title,
    String? note,
    bool? isCompleted,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    TaskColor? color,
    int? remind,
    RepeatType? repeat,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      isCompleted: isCompleted ?? this.isCompleted,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      color: color ?? this.color,
      remind: remind ?? this.remind,
      repeat: repeat ?? this.repeat,
    );
  }
}
