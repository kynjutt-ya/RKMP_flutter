import '../../helpers/preferences_helper.dart';
import '../../helpers/secure_storage_helper.dart';
import 'user_dto.dart';

abstract class UserDataSource {
  Future<UserDto?> getUserById(String id);
  Future<UserDto> updateUser(UserDto user);
  Future<UserDto?> getUserByEmail(String email);
  Future<void> updateLogin(String login);
  Future<String?> getLogin();
}

class UserLocalDataSource implements UserDataSource {
  final PreferencesHelper _prefsHelper = PreferencesHelper.instance;
  final SecureStorageHelper _secureStorage = SecureStorageHelper.instance;

  @override
  Future<UserDto?> getUserById(String id) async {
    final email = await _prefsHelper.getUserEmail();
    if (email == null || email.isEmpty) return null;
    
    return UserDto(
      id: id,
      name: await _prefsHelper.getUserName() ?? '',
      email: email,
      phone: await _prefsHelper.getUserPhone(),
      avatarUrl: await _prefsHelper.getAvatarUrl(),
    );
  }

  @override
  Future<UserDto> updateUser(UserDto user) async {
    await _prefsHelper.saveUserName(user.name);
    await _prefsHelper.saveUserEmail(user.email);
    if (user.phone != null) {
      await _prefsHelper.saveUserPhone(user.phone!);
    }
    if (user.avatarUrl != null) {
      await _prefsHelper.saveAvatarUrl(user.avatarUrl!);
    }
    return user;
  }

  @override
  Future<UserDto?> getUserByEmail(String email) async {
    final savedEmail = await _prefsHelper.getUserEmail();
    if (savedEmail != email) return null;
    
    return UserDto(
      id: email,
      name: await _prefsHelper.getUserName() ?? '',
      email: email,
      phone: await _prefsHelper.getUserPhone(),
      avatarUrl: await _prefsHelper.getAvatarUrl(),
    );
  }

  @override
  Future<void> updateLogin(String login) async {
    await _secureStorage.saveUserLogin(login);
  }

  @override
  Future<String?> getLogin() async {
    return await _secureStorage.getUserLogin();
  }
}

