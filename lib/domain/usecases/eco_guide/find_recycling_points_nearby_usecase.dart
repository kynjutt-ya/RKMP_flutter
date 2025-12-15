import '../../../core/models/recycling_point_model.dart';
import '../../interfaces/repositories/eco_guide_repository.dart';

/// Use case для поиска пунктов приема отходов поблизости
class FindRecyclingPointsNearbyUseCase {
  final EcoGuideRepository repository;

  FindRecyclingPointsNearbyUseCase(this.repository);

  Future<List<RecyclingPointModel>> call(
    double lat,
    double lon,
    double radiusKm,
  ) async {
    return await repository.findRecyclingPointsNearby(lat, lon, radiusKm);
  }
}

