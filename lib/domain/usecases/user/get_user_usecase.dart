import '../../../core/models/user_model.dart';
import '../../interfaces/repositories/user_repository.dart';

class GetUserUseCase {
  final UserRepository repository;

  GetUserUseCase(this.repository);

  Future<UserModel?> call(String id) async {
    if (id.isEmpty) {
      return null;
    }
    return await repository.getUserById(id);
  }
}

