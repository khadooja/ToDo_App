import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../data/models/task.dart';
import '../../presentation/pages/notification_screen.dart';

class NotifyHelper {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final BehaviorSubject<String> selectNotificationSubject =
      BehaviorSubject<String>();

  Future<void> initializeNotification() async {
    tz.initializeTimeZones();
    _configureSelectNotificationSubject();
    await _configureLocalTimeZone();

    // إعدادات أندرويد
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('appicon');

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
      initializationSettings,
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
      int id, String? title, String? body, String? payload) async {
    if (body != null) Get.dialog(Text(body));
  }

  // إشعار فوري
  Future<void> displayNotification(
      {required String title, required String body}) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
    );

    final DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    final NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformDetails,
      payload: 'Default_Sound',
    );
  }

  // إشعار مجدول
  Future<void> scheduledNotification(int hour, int minutes, Task task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id!,
      task.title,
      task.note,
      _nextInstanceOfScheduledTime(
          hour, minutes, task.remind!, task.repeat!, task.date!),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
          channelDescription: 'your_channel_description',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: '${task.title}|${task.note}|${task.startTime}|',
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
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

  tz.TZDateTime _nextInstanceOfScheduledTime(
      int hour, int minutes, int remind, String repeat, String date) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    var formatDate = DateFormat.yMd().parse(date);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, formatDate.year,
        formatDate.month, formatDate.day, hour, minutes);

    scheduledDate = afterRemind(remind, scheduledDate);

    if (scheduledDate.isBefore(now)) {
      if (repeat == 'Daily')
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      if (repeat == 'Weekly')
        scheduledDate = scheduledDate.add(const Duration(days: 7));
      if (repeat == 'Monthly') {
        scheduledDate = tz.TZDateTime(
            tz.local, now.year, now.month + 1, formatDate.day, hour, minutes);
      }
      if (repeat == 'Yearly') {
        scheduledDate = tz.TZDateTime(tz.local, now.year + 1, formatDate.month,
            formatDate.day, hour, minutes);
      }
    }

    return scheduledDate;
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    //final String timeZoneName = await DeviceTimezone.getTimeZone();
    tz.setLocalLocation(tz.getLocation(tz.local.name));
    //tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      await Get.to(() => NotificationScreen(payload: payload));
    });
  }

  void cancelNotification(Task task) async {
    await flutterLocalNotificationsPlugin.cancel(task.id!);
  }

  void cancelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
