import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState()) {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAvatar = prefs.getString('avatarUrl');
    final savedName = prefs.getString('userName') ?? '';
    final savedEmail = prefs.getString('userEmail') ?? '';
    final savedPhone = prefs.getString('userPhone') ?? '';
    final savedFavorites = prefs.getStringList('favoriteItems') ?? [];

    emit(state.copyWith(
      userName: savedName,
      userEmail: savedEmail,
      userPhone: savedPhone,
      avatarUrl: savedAvatar,
      favoriteItems: savedFavorites,
    ));
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', state.userName);
      await prefs.setString('userEmail', state.userEmail);
      await prefs.setString('userPhone', state.userPhone);
      if (state.avatarUrl != null && state.avatarUrl!.isNotEmpty) {
        if (state.avatarUrl!.length > 1000000) {
          debugPrint('Avatar URL too large, truncating...');
        }
        final success = await prefs.setString('avatarUrl', state.avatarUrl!);
        debugPrint('Avatar saved: $success, length: ${state.avatarUrl!.length}');
      } else {
        await prefs.remove('avatarUrl');
        debugPrint('Avatar removed');
      }
      await prefs.setStringList('favoriteItems', state.favoriteItems);
    } catch (e) {
      debugPrint('Error saving profile to prefs: $e');
    }
  }

  void updateProfile(String name, String email, String phone) {
    emit(state.copyWith(
      userName: name,
      userEmail: email,
      userPhone: phone,
      lastUpdated: DateTime.now(),
    ));
    _saveToPrefs();
  }

  Future<void> updateAvatar(String? avatarUrl) async {
    emit(state.copyWith(avatarUrl: avatarUrl));
    await _saveToPrefs();
  }

  void addToFavorites(String itemId) {
    final newFavorites = {...state.favoriteItems, itemId};
    emit(state.copyWith(favoriteItems: newFavorites.toList()));
    _saveToPrefs();
  }

  void removeFromFavorites(String itemId) {
    final newFavorites = state.favoriteItems.where((id) => id != itemId).toList();
    emit(state.copyWith(favoriteItems: newFavorites));
    _saveToPrefs();
  }
}

class ProfileState {
  final String userName;
  final String userEmail;
  final String userPhone;
  final String? avatarUrl;
  final List<String> favoriteItems;
  final DateTime? lastUpdated;

  const ProfileState({
    this.userName = '',
    this.userEmail = '',
    this.userPhone = '',
    this.avatarUrl,
    this.favoriteItems = const [],
    this.lastUpdated,
  });

  ProfileState copyWith({
    String? userName,
    String? userEmail,
    String? userPhone,
    String? avatarUrl,
    List<String>? favoriteItems,
    DateTime? lastUpdated,
  }) {
    return ProfileState(
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userPhone: userPhone ?? this.userPhone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      favoriteItems: favoriteItems ?? this.favoriteItems,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}