import '../../core/models/user_model.dart';
import '../../domain/interfaces/repositories/user_repository.dart';
import '../datasources/user/user_local_data_source.dart';
import '../datasources/user/user_mapper.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource dataSource;

  UserRepositoryImpl(this.dataSource);

  @override
  Future<UserModel?> getUserById(String id) async {
    final dto = await dataSource.getUserById(id);
    return dto != null ? UserMapper.toModel(dto) : null;
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    final dto = UserMapper.toDto(user);
    final updatedDto = await dataSource.updateUser(dto);
    return UserMapper.toModel(updatedDto);
  }

  @override
  Future<UserModel?> getUserByEmail(String email) async {
    final dto = await dataSource.getUserByEmail(email);
    return dto != null ? UserMapper.toModel(dto) : null;
  }
}

