/*import 'dart:async';
import 'package:flutter/services.dart';

class DeviceTimezone {
  static const MethodChannel _channel = MethodChannel('device_timezone');

  static Future<String> getTimeZone() async {
    try {
      final String tz = await _channel.invokeMethod('getTimeZone');
      return tz;
    } on PlatformException {
      return 'Unknown';
    }
  }
}*/
