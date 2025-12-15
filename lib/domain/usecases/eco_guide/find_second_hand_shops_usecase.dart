import '../../../core/models/recycling_point_model.dart';
import '../../interfaces/repositories/eco_guide_repository.dart';

/// Use case для поиска магазинов секонд-хенд поблизости
class FindSecondHandShopsUseCase {
  final EcoGuideRepository repository;

  FindSecondHandShopsUseCase(this.repository);

  Future<List<RecyclingPointModel>> call(
    double lat,
    double lon,
    double radiusKm,
  ) async {
    return await repository.findSecondHandShopsNearby(lat, lon, radiusKm);
  }
}
