import '../../../core/models/eco_impact_model.dart';
import '../../interfaces/repositories/eco_impact_repository.dart';

class GetImpactUseCase {
  final EcoImpactRepository repository;

  GetImpactUseCase(this.repository);

  Future<EcoImpactModel> call(String userId) async {
    if (userId.isEmpty) {
      throw Exception('ID пользователя не может быть пустым');
    }
    return await repository.getImpactByUserId(userId);
  }
}

