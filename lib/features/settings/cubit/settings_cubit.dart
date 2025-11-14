import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    emit(SettingsState(
      isDarkMode: prefs.getBool('isDarkMode') ?? false,
      language: prefs.getString('language') ?? 'ru',
      notificationsEnabled: prefs.getBool('notificationsEnabled') ?? true,
      searchHistoryEnabled: prefs.getBool('searchHistoryEnabled') ?? true,
      cacheSizeMB: prefs.getInt('cacheSizeMB') ?? 100,
    ));
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

class SettingsState {
  final bool isDarkMode;
  final String language;
  final bool notificationsEnabled;
  final bool searchHistoryEnabled;
  final int cacheSizeMB;

  const SettingsState({
    this.isDarkMode = false,
    this.language = 'ru',
    this.notificationsEnabled = true,
    this.searchHistoryEnabled = true,
    this.cacheSizeMB = 100,
  });

  SettingsState copyWith({
    bool? isDarkMode,
    String? language,
    bool? notificationsEnabled,
    bool? searchHistoryEnabled,
    int? cacheSizeMB,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      searchHistoryEnabled: searchHistoryEnabled ?? this.searchHistoryEnabled,
      cacheSizeMB: cacheSizeMB ?? this.cacheSizeMB,
    );
  }
}