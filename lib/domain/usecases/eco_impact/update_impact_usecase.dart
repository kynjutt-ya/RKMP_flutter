import '../../../core/models/eco_impact_model.dart';
import '../../interfaces/repositories/eco_impact_repository.dart';

class UpdateImpactUseCase {
  final EcoImpactRepository repository;

  UpdateImpactUseCase(this.repository);

  Future<EcoImpactModel> call(EcoImpactModel impact) async {
    return await repository.updateImpact(impact);
  }
}

