import 'package:permission_handler/permission_handler.dart';

Future<void> requestNotificationPermission() async {
  final status = await Permission.notification.status;
  if (status != PermissionStatus.granted) {
    await Permission.notification.request();
  }
}
