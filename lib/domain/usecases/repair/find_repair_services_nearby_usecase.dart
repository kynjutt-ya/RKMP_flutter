import '../../../core/models/repair_service_model.dart';
import '../../interfaces/repositories/repair_repository.dart';

/// Use case для поиска сервисов ремонта поблизости
class FindRepairServicesNearbyUseCase {
  final RepairRepository repository;

  FindRepairServicesNearbyUseCase(this.repository);

  Future<List<RepairServiceModel>> call(
    double lat,
    double lon,
    double radiusKm,
  ) async {
    return await repository.findRepairServicesNearby(lat, lon, radiusKm);
  }
}

