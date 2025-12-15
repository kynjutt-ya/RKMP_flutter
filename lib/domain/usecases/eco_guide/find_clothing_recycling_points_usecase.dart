import '../../../core/models/recycling_point_model.dart';
import '../../interfaces/repositories/eco_guide_repository.dart';

/// Use case для поиска пунктов приема одежды поблизости
class FindClothingRecyclingPointsUseCase {
  final EcoGuideRepository repository;

  FindClothingRecyclingPointsUseCase(this.repository);

  Future<List<RecyclingPointModel>> call(
    double lat,
    double lon,
    double radiusKm,
  ) async {
    return await repository.findClothingRecyclingPointsNearby(lat, lon, radiusKm);
  }
}

