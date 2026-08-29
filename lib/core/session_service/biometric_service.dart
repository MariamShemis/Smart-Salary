import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> authenticate({
    String localizedReason = "Please authenticate to access Smart Salary",
    bool biometricOnly = false,
  }) async {
    try {
      final isSupported = await auth.isDeviceSupported();
      final canCheck = await auth.canCheckBiometrics;

      debugPrint("isSupported = $isSupported");
      debugPrint("canCheck = $canCheck");

      if (!isSupported && !canCheck) return false;

      final result = await auth.authenticate(
        localizedReason: localizedReason,
        biometricOnly: biometricOnly,
        persistAcrossBackgrounding: true,
      );

      debugPrint("result = $result");
      return result;
    } catch (e, s) {
      debugPrint("Biometric Error: $e");
      debugPrintStack(stackTrace: s);
      return false;
    }
  }
}