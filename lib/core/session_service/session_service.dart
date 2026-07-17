import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _onboardingKey = "onboarding_completed";

  static Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  static Future<bool> get onboardingCompleted async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }
}