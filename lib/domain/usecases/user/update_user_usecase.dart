import '../../../core/models/user_model.dart';
import '../../interfaces/repositories/user_repository.dart';

class UpdateUserUseCase {
  final UserRepository repository;

  UpdateUserUseCase(this.repository);

  Future<UserModel> call(UserModel user) async {
    if (user.id.isEmpty) {
      throw Exception('ID пользователя не может быть пустым');
    }
    if (user.email.isEmpty) {
      throw Exception('Email не может быть пустым');
    }
    return await repository.updateUser(user);
  }
}

