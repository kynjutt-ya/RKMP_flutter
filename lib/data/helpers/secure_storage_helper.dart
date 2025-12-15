import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  static final SecureStorageHelper instance = SecureStorageHelper._init();
  static FlutterSecureStorage? _storage;
  SharedPreferences? _prefs;

  SecureStorageHelper._init() {
    if (!kIsWeb) {
      _storage = const FlutterSecureStorage(
        aOptions: AndroidOptions(
          encryptedSharedPreferences: true,
        ),
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock_this_device,
        ),
      );
    }
  }

  Future<SharedPreferences> get _webPrefs async {
    if (_prefs != null) return _prefs!;
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  FlutterSecureStorage? get storage {
    if (kIsWeb) return null;
    _storage ??= const FlutterSecureStorage(
        aOptions: AndroidOptions(
          encryptedSharedPreferences: true,
        ),
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock_this_device,
        ),
      );
    return _storage;
  }

  Future<void> saveAuthToken(String token) async {
    if (kIsWeb) {
      final prefs = await _webPrefs;
      await prefs.setString('auth_token', token);
    } else {
      await storage?.write(key: 'auth_token', value: token);
    }
  }

  Future<String?> getAuthToken() async {
    if (kIsWeb) {
      final prefs = await _webPrefs;
      return prefs.getString('auth_token');
    } else {
      return await storage?.read(key: 'auth_token');
    }
  }

  Future<void> saveRefreshToken(String token) async {
    if (kIsWeb) {
      final prefs = await _webPrefs;
      await prefs.setString('refresh_token', token);
    } else {
      await storage?.write(key: 'refresh_token', value: token);
    }
  }

  Future<String?> getRefreshToken() async {
    if (kIsWeb) {
      final prefs = await _webPrefs;
      return prefs.getString('refresh_token');
    } else {
      return await storage?.read(key: 'refresh_token');
    }
  }

  Future<void> deleteAuthToken() async {
    if (kIsWeb) {
      final prefs = await _webPrefs;
      await prefs.remove('auth_token');
    } else {
      await storage?.delete(key: 'auth_token');
    }
  }

  Future<void> deleteRefreshToken() async {
    if (kIsWeb) {
      final prefs = await _webPrefs;
      await prefs.remove('refresh_token');
    } else {
      await storage?.delete(key: 'refresh_token');
    }
  }

  Future<void> clearAll() async {
    if (kIsWeb) {
      final prefs = await _webPrefs;
      await prefs.remove('auth_token');
      await prefs.remove('refresh_token');
    } else {
      await storage?.deleteAll();
    }
  }
}

