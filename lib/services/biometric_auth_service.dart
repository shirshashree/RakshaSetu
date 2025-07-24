import 'dart:io';
import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  static Future<bool> authenticateUser() async {
    // ✅ Skip biometric on unsupported platforms like Windows for demo/testing
    if (!(Platform.isAndroid || Platform.isIOS)) {
      print(
        '[DEBUG] Biometric skipped: running on ${Platform.operatingSystem}',
      );
      return true; // Simulate success
    }

    final auth = LocalAuthentication();
    bool canCheck = await auth.canCheckBiometrics;
    if (!canCheck) {
      print('[DEBUG] Device cannot check biometrics');
      return false;
    }

    try {
      return await auth.authenticate(
        localizedReason: 'Authenticate to enable Secure Mode',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print('[ERROR] Biometric auth error: $e');
      return false;
    }
  }
}
