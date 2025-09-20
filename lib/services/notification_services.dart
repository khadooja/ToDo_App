import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todo/ui/pages/notification_screen.dart';

class NotifyHelper {
  // Singleton instance
  static final NotifyHelper _instance = NotifyHelper._internal();
  factory NotifyHelper() => _instance;
  NotifyHelper._internal();
  intialize() async {
    tz.initializeTimeZones();
    //tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// تهيئة الإشعارات (يُستدعى مرة واحدة مثلاً في main)
  Future<void> initializeNotifications() async {
    // تهيئة التايم زون
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Riyadh')); // غيّر حسب منطقتك

    // إعدادات Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    // إعدادات iOS / macOS
    final IOSInitializationSettings initializationSettingsIOS =
        const IOSInitializationSettings();

    final MacOSInitializationSettings initializationSettingsMacOS =
        const MacOSInitializationSettings();
    onDidReceiveLocalNotification:
    onDidReceiveLocalNotification;

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS,
    );
    // onDidReceiveNotificationResponse: onDidReceiveNotificationResponse;);

    // تهيئة البلجن
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        Get.dialog(
          AlertDialog(
            title: const Text("Notification Clicked"),
            content: Text(payload ?? "No payload"),
          ),
        );
      },
    );

    /// إشعار فوري
    Future<void> showNotification() async {
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        'your_channel_description', // هذا مطلوب (ما هو named)
        importance: Importance.max,
        priority: Priority.high,
      );

      const NotificationDetails notificationDetails =
          NotificationDetails(android: androidNotificationDetails);

      await flutterLocalNotificationsPlugin.show(
        0,
        'Plain title',
        'Plain body',
        notificationDetails,
        payload: 'item x',
      );
    }

    Future<void> selectNotification(int id, String payload) async {
      if (payload != null) {
        print('notification payload: $payload');
      } else {
        await Get.to(() => NotificationScreen(payload: payload));
      }

      /// إشعار مجدول
      Future<void> scheduleNotification() async {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          0,
          'Scheduled title',
          'Scheduled body',
          tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'your_channel_id',
              'your_channel_name',
              'your channel description', // ← هنا description إلزامي في النسخ القديمة
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
          androidAllowWhileIdle: true, // ← هذا هو الصحيح
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    }
  }

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // عرض حوار أو أي شيء تريده عند استلام إشعار محلي على iOS
    Get.dialog(Text(body!));
  }

  Future<void> displayNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'your_channel_id', // ID
      'your_channel_name', // اسم القناة
      'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker', // يظهر في شريط الحالة
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: IOSNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.show(
      0, // ID فريد لكل إشعار
      title,
      body,
      platformDetails,
      payload: 'item x', // ممكن تمرر بيانات إضافية هنا
    );
  }

  void scheduledNotification() {
    flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      "Scheduled Notification",
      "This is the body of the scheduled notification",
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
          'your channel description', // ← هنا description إلزامي في النسخ القديمة
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true, // ← هذا هو الصحيح
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
}
