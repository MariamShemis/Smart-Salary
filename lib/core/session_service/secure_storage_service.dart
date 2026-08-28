import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> saveLogin({
    required String email,
    required String password,
  }) async {
    await _storage.write(key: "email", value: email);
    await _storage.write(key: "password", value: password);
    await _storage.write(key: "provider", value: "email");
  }

  static Future<void> saveGoogleLogin({required String email}) async {
    await _storage.write(key: "email", value: email);
    await _storage.write(key: "provider", value: "google");
  }

  static Future<bool> isGoogleUser() async {
    final provider = await _storage.read(key: "provider");
    return provider == "google";
  }

  static Future<String?> getEmail() => _storage.read(key: "email");
  static Future<String?> getPassword() => _storage.read(key: "password");

  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}