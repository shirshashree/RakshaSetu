import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import '../services/secure_mode_manager.dart';

class AppCard extends StatelessWidget {
  final Application app;
  final bool secureMode;

  AppCard({required this.app, required this.secureMode});

  @override
  Widget build(BuildContext context) {
    final isAllowed = SecureModeManager.approvedPackages.contains(
      app.packageName,
    );

    return ListTile(
      leading: app is ApplicationWithIcon
          ? Image.memory((app as ApplicationWithIcon).icon, width: 40)
          : null,
      title: Text(app.appName),
      subtitle: Text(app.packageName),
      trailing: secureMode
          ? Icon(
              isAllowed ? Icons.check_circle : Icons.block,
              color: isAllowed ? Colors.green : Colors.red,
            )
          : null,
      onTap: () {
        if (secureMode && !isAllowed) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Blocked in secure mode")));
        } else {
          DeviceApps.openApp(app.packageName);
        }
      },
    );
  }
}
