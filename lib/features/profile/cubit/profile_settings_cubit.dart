import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSettingsCubit extends Cubit<ProfileSettingsState> {
  ProfileSettingsCubit() : super(const ProfileSettingsState()) {
    // Загружаем настройки асинхронно, не блокируя запуск приложения
    Future.microtask(() {
      _loadSettings().catchError((error) {
        debugPrint('Error loading settings: $error');
        // Продолжаем с состоянием по умолчанию, если загрузка не удалась
      });
    });
  }

  Future<void> _loadSettings() async {
    try {
    final prefs = await SharedPreferences.getInstance();
    emit(ProfileSettingsState(
      isDarkMode: prefs.getBool('isDarkMode') ?? false,
      language: prefs.getString('language') ?? 'ru',
      notificationsEnabled: prefs.getBool('notificationsEnabled') ?? true,
      searchHistoryEnabled: prefs.getBool('searchHistoryEnabled') ?? true,
      cacheSizeMB: prefs.getInt('cacheSizeMB') ?? 100,
    ));
    } catch (e) {
      debugPrint('Error loading settings from SharedPreferences: $e');
      // Оставляем состояние по умолчанию
    }
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    }
  }

  void toggleDarkMode(bool value) {
    _saveSetting('isDarkMode', value);
    emit(state.copyWith(isDarkMode: value));
  }

  void changeLanguage(String language) {
    _saveSetting('language', language);
    emit(state.copyWith(language: language));
  }

  void toggleNotifications(bool enabled) {
    _saveSetting('notificationsEnabled', enabled);
    emit(state.copyWith(notificationsEnabled: enabled));
  }

  void toggleSearchHistory(bool enabled) {
    _saveSetting('searchHistoryEnabled', enabled);
    emit(state.copyWith(searchHistoryEnabled: enabled));
  }

  void setCacheSize(int size) {
    _saveSetting('cacheSizeMB', size);
    emit(state.copyWith(cacheSizeMB: size));
  }
}

class ProfileSettingsState {
  final bool isDarkMode;
  final String language;
  final bool notificationsEnabled;
  final bool searchHistoryEnabled;
  final int cacheSizeMB;

  const ProfileSettingsState({
    this.isDarkMode = false,
    this.language = 'ru',
    this.notificationsEnabled = true,
    this.searchHistoryEnabled = true,
    this.cacheSizeMB = 100,
  });

  ProfileSettingsState copyWith({
    bool? isDarkMode,
    String? language,
    bool? notificationsEnabled,
    bool? searchHistoryEnabled,
    int? cacheSizeMB,
  }) {
    return ProfileSettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      searchHistoryEnabled: searchHistoryEnabled ?? this.searchHistoryEnabled,
      cacheSizeMB: cacheSizeMB ?? this.cacheSizeMB,
    );
  }
}