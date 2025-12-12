import '../../../core/models/user_model.dart';
import 'user_dto.dart';

class UserMapper {
  static UserModel toModel(UserDto dto) {
    return UserModel(
      id: dto.id,
      name: dto.name,
      email: dto.email,
      phone: dto.phone,
      avatarUrl: dto.avatarUrl,
    );
  }

  static UserDto toDto(UserModel model) {
    return UserDto(
      id: model.id,
      name: model.name,
      email: model.email,
      phone: model.phone,
      avatarUrl: model.avatarUrl,
    );
  }

  static List<UserModel> toModelList(List<UserDto> dtos) {
    return dtos.map((dto) => toModel(dto)).toList();
  }
}

