import 'package:device_apps/device_apps.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureModeManager {
  static const List<String> approvedPackages = [
    'com.google.android.apps.nbu.paisa.user', // Google Pay
    'net.one97.paytm', // Paytm
    'com.phonepe.app', // PhonePe
  ];

  static Future<List<Application>> getInstalledApps() async {
    return await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      includeSystemApps: false,
      onlyAppsWithLaunchIntent: true,
    );
  }

  static bool isAppApproved(String packageName) {
    return approvedPackages.contains(packageName);
  }

  static Future<void> setSecureModeEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('secure_mode', value);
  }

  static Future<bool> isSecureModeEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('secure_mode') ?? false;
  }
}
