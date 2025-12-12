import '../../../core/models/recycling_point_model.dart';
import '../../interfaces/repositories/eco_guide_repository.dart';

class GetAllRecyclingPointsUseCase {
  final EcoGuideRepository repository;

  GetAllRecyclingPointsUseCase(this.repository);

  Future<List<RecyclingPointModel>> call() async {
    return await repository.getAllRecyclingPoints();
  }
}

