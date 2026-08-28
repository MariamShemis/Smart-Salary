import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> authenticate() async {
    try {
      final isSupported = await auth.isDeviceSupported();
      final canCheck = await auth.canCheckBiometrics;

      debugPrint("isSupported = $isSupported");
      debugPrint("canCheck = $canCheck");

      final available = await auth.getAvailableBiometrics();
      debugPrint("available = $available");

      final result = await auth.authenticate(
        localizedReason: "Please authenticate",
        biometricOnly: false,
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