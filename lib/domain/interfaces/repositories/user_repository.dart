import '../../../core/models/user_model.dart';

abstract class UserRepository {
  Future<UserModel?> getUserById(String id);
  Future<UserModel> updateUser(UserModel user);
  Future<UserModel?> getUserByEmail(String email);
}

