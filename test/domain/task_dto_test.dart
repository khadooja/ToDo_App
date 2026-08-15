import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app_new/data/db/task_dto.dart';
import 'package:todo_app_new/domain/entities/task.dart';

void main() {
  group('TaskDto', () {
    test('round-trips a fully populated Task through toMap/fromMap', () {
      final original = Task(
        id: 42,
        title: 'Write tests',
        note: 'Cover the repository layer',
        isCompleted: true,
        date: DateTime(2026, 3, 7),
        startTime: const TimeOfDay(hour: 9, minute: 5),
        endTime: const TimeOfDay(hour: 10, minute: 30),
        color: TaskColor.pink,
        remind: 15,
        repeat: RepeatType.weekly,
      );

      final map = TaskDto.toMap(original);
      final restored = TaskDto.fromMap(map);

      expect(restored.id, original.id);
      expect(restored.title, original.title);
      expect(restored.note, original.note);
      expect(restored.isCompleted, original.isCompleted);
      expect(restored.date, original.date);
      expect(restored.startTime, original.startTime);
      expect(restored.endTime, original.endTime);
      expect(restored.color, original.color);
      expect(restored.remind, original.remind);
      expect(restored.repeat, original.repeat);
    });

    test('stores dates as unambiguous ISO yyyy-MM-dd, not a locale format', () {
      final task = Task(
        title: 't',
        note: 'n',
        date: DateTime(
          2026,
          1,
          5,
        ), // Jan 5th - the classic day/month mixup date
        startTime: const TimeOfDay(hour: 8, minute: 0),
        endTime: const TimeOfDay(hour: 9, minute: 0),
      );

      final map = TaskDto.toMap(task);

      expect(map['date'], '2026-01-05');
    });

    test('stores times as 24h HH:mm, not a 12h locale format', () {
      final task = Task(
        title: 't',
        note: 'n',
        date: DateTime(2026, 1, 1),
        startTime: const TimeOfDay(hour: 14, minute: 5),
        endTime: const TimeOfDay(hour: 23, minute: 59),
      );

      final map = TaskDto.toMap(task);

      expect(map['startTime'], '14:05');
      expect(map['endTime'], '23:59');
    });

    test(
      'fromMap falls back sanely on malformed/missing fields instead of throwing',
      () {
        final restored = TaskDto.fromMap(const {
          'id': 1,
          'title': null,
          'note': null,
          'isCompleted': null,
          'date': 'not-a-date',
          'startTime': 'garbage',
          'endTime': null,
          'color': 99, // out of range
          'remind': null,
          'repeat': 'NotARealRepeatValue',
        });

        expect(restored.title, '');
        expect(restored.note, '');
        expect(restored.isCompleted, false);
        expect(restored.color, TaskColor.blue); // safe fallback
        expect(restored.repeat, RepeatType.none); // safe fallback
        expect(restored.remind, 5); // default
      },
    );

    test('repeat label mapping is stable in both directions', () {
      for (final repeat in RepeatType.values) {
        expect(RepeatTypeX.fromLabel(repeat.label), repeat);
      }
    });
  });
}
