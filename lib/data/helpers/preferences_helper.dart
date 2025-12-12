import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  static final PreferencesHelper instance = PreferencesHelper._init();
  SharedPreferences? _prefs;

  PreferencesHelper._init();

  Future<SharedPreferences> get prefs async {
    if (_prefs != null) return _prefs!;
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<void> saveUserName(String name) async {
    final preferences = await prefs;
    await preferences.setString('userName', name);
  }

  Future<String?> getUserName() async {
    final preferences = await prefs;
    return preferences.getString('userName');
  }

  Future<void> saveUserEmail(String email) async {
    final preferences = await prefs;
    await preferences.setString('userEmail', email);
  }

  Future<String?> getUserEmail() async {
    final preferences = await prefs;
    return preferences.getString('userEmail');
  }

  Future<void> saveUserPhone(String phone) async {
    final preferences = await prefs;
    await preferences.setString('userPhone', phone);
  }

  Future<String?> getUserPhone() async {
    final preferences = await prefs;
    return preferences.getString('userPhone');
  }

  Future<void> saveAvatarUrl(String url) async {
    final preferences = await prefs;
    await preferences.setString('avatarUrl', url);
  }

  Future<String?> getAvatarUrl() async {
    final preferences = await prefs;
    return preferences.getString('avatarUrl');
  }

  Future<void> clearAll() async {
    final preferences = await prefs;
    await preferences.clear();
  }
}

