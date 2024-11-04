import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AndroidVersionCheck {
  static const String _keyAndroid13Check = 'is_android_13_or_above';

  static Future<bool> checkAndSaveAndroidVersion() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if value already exists
    if (prefs.containsKey(_keyAndroid13Check)) {
      return prefs.getBool(_keyAndroid13Check) ?? false;
    }

    // Get Android version
    bool isAndroid13OrAbove = false;
    try {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      final sdkVersion = androidInfo.version.sdkInt;
      isAndroid13OrAbove = sdkVersion >= 33;
    } catch (e) {
      print('Error getting Android version: $e');
    }

    // Save result
    await prefs.setBool(_keyAndroid13Check, isAndroid13OrAbove);
    return isAndroid13OrAbove;
  }

  static Future<bool> getIsAndroid13OrAbove() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyAndroid13Check) ?? false;
  }
}


// Get saved value later
// bool savedValue = await AndroidVersionCheck.getIsAndroid13OrAbove();
