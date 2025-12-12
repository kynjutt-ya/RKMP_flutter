import 'package:shared_preferences/shared_preferences.dart';
import 'user_dto.dart';

abstract class UserDataSource {
  Future<UserDto?> getUserById(String id);
  Future<UserDto> updateUser(UserDto user);
  Future<UserDto?> getUserByEmail(String email);
}

class UserLocalDataSource implements UserDataSource {
  @override
  Future<UserDto?> getUserById(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('userEmail');
    if (email == null || email.isEmpty) return null;
    
    return UserDto(
      id: id,
      name: prefs.getString('userName') ?? '',
      email: email,
      phone: prefs.getString('userPhone'),
      avatarUrl: prefs.getString('avatarUrl'),
    );
  }

  @override
  Future<UserDto> updateUser(UserDto user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', user.name);
    await prefs.setString('userEmail', user.email);
    if (user.phone != null) {
      await prefs.setString('userPhone', user.phone!);
    }
    if (user.avatarUrl != null) {
      await prefs.setString('avatarUrl', user.avatarUrl!);
    }
    return user;
  }

  @override
  Future<UserDto?> getUserByEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('userEmail');
    if (savedEmail != email) return null;
    
    return UserDto(
      id: email,
      name: prefs.getString('userName') ?? '',
      email: email,
      phone: prefs.getString('userPhone'),
      avatarUrl: prefs.getString('avatarUrl'),
    );
  }
}

