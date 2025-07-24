import 'package:flutter/material.dart';
import '../services/secure_mode_manager.dart';
import '../services/biometric_auth_service.dart';
import 'message_scanner.dart';
import 'secure_mode_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _secureModeEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSecureModeState();
  }

  Future<void> _loadSecureModeState() async {
    bool isEnabled = await SecureModeManager.isSecureModeEnabled();
    setState(() {
      _secureModeEnabled = isEnabled;
    });
  }

  Future<void> _enterSecureMode() async {
    bool success = await BiometricAuthService.authenticateUser();
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Biometric authentication failed')),
      );
      return;
    }

    await SecureModeManager.setSecureModeEnabled(true);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SecureModeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('RakshaSetu')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.sms),
              label: Text('Scan Messages'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MessageScannerScreen()),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.lock),
              label: Text('Enter Secure Mode'),
              onPressed: _enterSecureMode,
            ),
          ],
        ),
      ),
    );
  }
}
