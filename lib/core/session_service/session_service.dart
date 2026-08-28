import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _onboardingKey = "onboarding_completed";
  static const String _biometricEmailKey = "biometric_email";

  static Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  static Future<bool> get onboardingCompleted async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  static Future<void> enableBiometric(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_biometricEmailKey, email);
  }

  static Future<void> disableBiometric() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_biometricEmailKey);
  }

  static Future<String?> get biometricEmail async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_biometricEmailKey);
  }

  static Future<bool> isBiometricEnabled(String email) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_biometricEmailKey) == email;
  }
}