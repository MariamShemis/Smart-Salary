import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String _languageKey = 'app_language';
  static SharedPreferences? _prefs;

  static Future<void> _ensureInitialized() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  static Future<bool> saveLanguage(String languageCode) async {
    try {
      await _ensureInitialized();
      return await _prefs!.setString(_languageKey, languageCode);
    } catch (e) {
      print('Error saving language: $e');
      return false;
    }
  }

  static Future<String> getSavedLanguage() async {
    try {
      await _ensureInitialized();
      return _prefs!.getString(_languageKey) ?? 'en';
    } catch (e) {
      print('Error getting saved language: $e');
      return 'en';
    }
  }

  static Future<bool> clearLanguage() async {
    try {
      await _ensureInitialized();
      return await _prefs!.remove(_languageKey);
    } catch (e) {
      print('Error clearing language: $e');
      return false;
    }
  }

  static Future<bool> isArabic() async {
    final lang = await getSavedLanguage();
    return lang == 'ar';
  }

  static Future<bool> isEnglish() async {
    final lang = await getSavedLanguage();
    return lang == 'en';
  }

  static Future<void> printStoredLanguage() async {
    try {
      await _ensureInitialized();
      final savedLang = _prefs!.getString(_languageKey);
      print('📱 Stored Language: $savedLang');
    } catch (e) {
      print('Error printing stored language: $e');
    }
  }
}