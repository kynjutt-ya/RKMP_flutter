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

  Future<void> saveUserLogin(String login) async {
    if (kIsWeb) {
      final prefs = await _webPrefs;
      await prefs.setString('user_login', login);
    } else {
      await storage?.write(key: 'user_login', value: login);
    }
  }

  Future<String?> getUserLogin() async {
    if (kIsWeb) {
      final prefs = await _webPrefs;
      return prefs.getString('user_login');
    } else {
      return await storage?.read(key: 'user_login');
    }
  }

  Future<void> saveUserPassword(String password) async {
    if (kIsWeb) {
      final prefs = await _webPrefs;
      await prefs.setString('user_password', password);
    } else {
      await storage?.write(key: 'user_password', value: password);
    }
  }

  Future<String?> getUserPassword() async {
    if (kIsWeb) {
      final prefs = await _webPrefs;
      return prefs.getString('user_password');
    } else {
      return await storage?.read(key: 'user_password');
    }
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

  Future<void> deleteUserLogin() async {
    if (kIsWeb) {
      final prefs = await _webPrefs;
      await prefs.remove('user_login');
    } else {
      await storage?.delete(key: 'user_login');
    }
  }

  Future<void> deleteUserPassword() async {
    if (kIsWeb) {
      final prefs = await _webPrefs;
      await prefs.remove('user_password');
    } else {
      await storage?.delete(key: 'user_password');
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
      await prefs.remove('user_login');
      await prefs.remove('user_password');
      await prefs.remove('auth_token');
      await prefs.remove('refresh_token');
    } else {
      await storage?.deleteAll();
    }
  }
}

