import 'package:device_apps/device_apps.dart';

class AppInfo {
  final String appName;
  final String packageName;
  final bool isSystemApp;
  final bool isApproved;

  AppInfo({
    required this.appName,
    required this.packageName,
    required this.isSystemApp,
    required this.isApproved,
  });

  factory AppInfo.fromDeviceApp(Application app, bool isApproved) {
    return AppInfo(
      appName: app.appName,
      packageName: app.packageName,
      isSystemApp: app.systemApp,
      isApproved: isApproved,
    );
  }
}
