import 'package:flutter/material.dart';
import '../services/secure_mode_manager.dart';
import '../services/biometric_auth_service.dart';

class SecureModeScreen extends StatefulWidget {
  const SecureModeScreen({super.key});

  @override
  _SecureModeScreenState createState() => _SecureModeScreenState();
}

class _SecureModeScreenState extends State<SecureModeScreen> {
  bool _secureModeEnabled = false;

  @override
  void initState() {
    super.initState();
    checkSecureMode();
  }

  Future<void> checkSecureMode() async {
    final enabled = await SecureModeManager.isSecureModeEnabled();
    setState(() {
      _secureModeEnabled = enabled;
    });
  }

  Future<void> toggleSecureMode() async {
    if (!_secureModeEnabled) {
      bool auth = await BiometricAuthService.authenticateUser();
      if (!auth) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Authentication failed')));
        return;
      }
    }

    await SecureModeManager.setSecureModeEnabled(!_secureModeEnabled);
    setState(() {
      _secureModeEnabled = !_secureModeEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Secure Mode')),
      body: Center(
        child: ElevatedButton(
          onPressed: toggleSecureMode,
          child: Text(
            _secureModeEnabled ? "Disable Secure Mode" : "Enable Secure Mode",
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:device_apps/device_apps.dart';
// import '../services/secure_mode_manager.dart';

// class SecureModeScreen extends StatefulWidget {
//   @override
//   _SecureModeScreenState createState() => _SecureModeScreenState();
// }

// class _SecureModeScreenState extends State<SecureModeScreen> {
//   List<Application> _apps = [];
//   bool _secureMode = false;

//   @override
//   void initState() {
//     super.initState();
//     loadApps();
//   }

//   Future<void> loadApps() async {
//     _secureMode = await SecureModeManager.isSecureModeEnabled();
//     _apps = await SecureModeManager.getInstalledApps();
//     setState(() {});
//   }

//   void toggleSecureMode() async {
//     if (_secureMode) {
//       await SecureModeManager.disableSecureMode();
//     } else {
//       await SecureModeManager.enableSecureMode();
//     }
//     loadApps();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final approved = SecureModeManager.approvedPackages;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Secure Mode (${_secureMode ? "ON" : "OFF"})"),
//         actions: [
//           IconButton(
//             icon: Icon(_secureMode ? Icons.lock_open : Icons.lock),
//             onPressed: toggleSecureMode,
//           )
//         ],
//       ),
//       body: ListView.builder(
//         itemCount: _apps.length,
//         itemBuilder: (context, index) {
//           final app = _apps[index];
//           final isAllowed = approved.contains(app.packageName);

//           return ListTile(
//             leading: app is ApplicationWithIcon
//                 ? Image.memory(app.icon, width: 40)
//                 : null,
//             title: Text(app.appName),
//             subtitle: Text(app.packageName),
//             trailing: _secureMode
//                 ? Icon(
//                     isAllowed ? Icons.check_circle : Icons.block,
//                     color: isAllowed ? Colors.green : Colors.red,
//                   )
//                 : null,
//             onTap: () {
//               if (_secureMode && !isAllowed) {
//                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                   content: Text("This app is blocked in secure mode"),
//                 ));
//               } else {
//                 DeviceApps.openApp(app.packageName);
//               }
//             },
//           );
//         },
//       ),
//     );
//   }
// }

