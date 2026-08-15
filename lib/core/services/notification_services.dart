import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:todo_app_new/domain/entities/task.dart';
import '../../presentation/pages/notification_screen.dart';
import 'package:todo_app_new/core/services/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotifyHelper {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final BehaviorSubject<String> selectNotificationSubject =
      BehaviorSubject<String>();

  Future<void> initializeNotification() async {
    tz.initializeTimeZones();
    await requestNotificationPermission();
    _configureSelectNotificationSubject();
    await _configureLocalTimeZone();

    // إعدادات أندرويد
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    // إعدادات iOS/ macOS الحديثة
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
          //onDidReceiveLocalNotification: onDidReceiveLocalNotification,
        );

    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
          macOS: initializationSettingsDarwin,
        );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        final String? payload = response.payload;
        if (payload != null) {
          selectNotificationSubject.add(payload);
        }
      },
    );
  }

  // للنسخ القديمة من iOS
  Future<void> onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {
    if (body != null) Get.dialog(Text(body));
  }

  // إشعار فوري
  Future<void> displayNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
          channelDescription: 'your_channel_description',
          importance: Importance.max,
          priority: Priority.high,
        );

    final DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    final NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id: 0,
      title: title,
      body: body,
      notificationDetails: platformDetails,
      payload: 'Default_Sound',
    );
  }

  /// إشعار مجدول
  ///
  /// Signature change from Phase 1: now takes the whole Task instead of
  /// separate (hour, minutes, task) parameters, since Task carries
  /// startTime as a real TimeOfDay now — there's nothing left to parse out
  /// of it beforehand.
  Future<void> scheduledNotification(Task task) async {
    if (task.id == null) return;

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: task.id!,
      title: task.title,
      body: task.note,
      scheduledDate: _nextInstanceOfScheduledTime(task),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
          channelDescription: 'your_channel_description',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: '${task.title}|${task.note}|${_formatTime(task.startTime)}|',
      matchDateTimeComponents: _matchComponentsFor(task.repeat),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  String _formatTime(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  /// Maps a task's repeat setting to the recurrence rule the OS should use.
  /// Returns null for a one-off ("None") notification.
  DateTimeComponents? _matchComponentsFor(RepeatType repeat) {
    switch (repeat) {
      case RepeatType.daily:
        return DateTimeComponents.time;
      case RepeatType.weekly:
        return DateTimeComponents.dayOfWeekAndTime;
      case RepeatType.monthly:
        return DateTimeComponents.dayOfMonthAndTime;
      case RepeatType.yearly:
        return DateTimeComponents.dateAndTime;
      case RepeatType.none:
        return null;
    }
  }

  tz.TZDateTime afterRemind(int remind, tz.TZDateTime scheduledDate) {
    if (remind == 5) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 5));
    }
    if (remind == 10) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 10));
    }
    if (remind == 15) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 15));
    }
    if (remind == 20) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 20));
    }
    return scheduledDate;
  }

  /// BUG FIX (roadmap Phase 2, item 9): this used to parse task.date /
  /// task.startTime out of locale-formatted strings (DateFormat.yMd()
  /// .parse(...), trying both "HH:mm" and 12-hour "h:mm a"), which was the
  /// root cause of the try/catch parsing blocks scattered through the old
  /// codebase. Task now stores date as a real DateTime and start/end time
  /// as TimeOfDay, so there's nothing to parse here anymore.
  tz.TZDateTime _nextInstanceOfScheduledTime(Task task) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      task.date.year,
      task.date.month,
      task.date.day,
      task.startTime.hour,
      task.startTime.minute,
    );

    scheduledDate = afterRemind(task.remind, scheduledDate);

    if (scheduledDate.isBefore(now)) {
      switch (task.repeat) {
        case RepeatType.daily:
          scheduledDate = scheduledDate.add(const Duration(days: 1));
          break;
        case RepeatType.weekly:
          scheduledDate = scheduledDate.add(const Duration(days: 7));
          break;
        case RepeatType.monthly:
          scheduledDate = tz.TZDateTime(
            tz.local,
            now.year,
            now.month + 1,
            task.date.day,
            task.startTime.hour,
            task.startTime.minute,
          );
          break;
        case RepeatType.yearly:
          scheduledDate = tz.TZDateTime(
            tz.local,
            now.year + 1,
            task.date.month,
            task.date.day,
            task.startTime.hour,
            task.startTime.minute,
          );
          break;
        case RepeatType.none:
          // Known follow-up (unchanged from Phase 1): a one-off task whose
          // time has already passed today will still be scheduled in the
          // past, which flutter_local_notifications fires immediately.
          // That's a product decision (fire now vs. skip vs. prompt), not
          // a pure bug fix, so it's intentionally out of scope here.
          break;
      }
    }

    return scheduledDate;
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(tz.local.name));
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      await Get.to(() => NotificationScreen(payload: payload));
    });
  }

  void cancelNotification(Task task) async {
    if (task.id == null) return;
    await flutterLocalNotificationsPlugin.cancel(id: task.id!);
  }

  void cancelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<bool> checkNotificationPermission() async {
    final bool? granted = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.areNotificationsEnabled();

    return granted ?? false;
  }
}
