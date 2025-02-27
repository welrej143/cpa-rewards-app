import 'dart:io';
import 'package:flutter/foundation.dart'; // ✅ Detect Web
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService {
  static Future<String> getUserDevice() async {
    if (kIsWeb) {
      return "Web"; // ✅ Web Support
    } else if (Platform.isAndroid) {
      return await _getAndroidId(); // ✅ Android Support
    } else if (Platform.isIOS) {
      return await _getIOSId(); // ✅ iOS Support
    } else {
      return "Unknown Device";
    }
  }

  /// ✅ Get Unique Android Device ID
  static Future<String> _getAndroidId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id; // Returns Unique Android ID
  }

  /// ✅ Get Unique iOS Device ID
  static Future<String> _getIOSId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return iosInfo.identifierForVendor ?? "Unknown iOS ID";
  }
}
