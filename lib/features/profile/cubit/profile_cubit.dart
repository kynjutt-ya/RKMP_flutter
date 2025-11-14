import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState());

  void updateProfile(String name, String email, String phone) {
    emit(state.copyWith(
      userName: name,
      userEmail: email,
      userPhone: phone,
      lastUpdated: DateTime.now(),
    ));
  }

  void updateAvatar(String avatarUrl) {
    emit(state.copyWith(avatarUrl: avatarUrl));
  }

  void addToFavorites(String itemId) {
    final newFavorites = {...state.favoriteItems, itemId};
    emit(state.copyWith(favoriteItems: newFavorites.toList()));
  }

  void removeFromFavorites(String itemId) {
    final newFavorites = state.favoriteItems.where((id) => id != itemId).toList();
    emit(state.copyWith(favoriteItems: newFavorites));
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