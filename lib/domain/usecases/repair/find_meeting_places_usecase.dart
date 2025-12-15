import '../../../core/models/repair_service_model.dart';
import '../../interfaces/repositories/repair_repository.dart';

/// Use case для поиска мест для безопасных встреч поблизости
class FindMeetingPlacesUseCase {
  final RepairRepository repository;

  FindMeetingPlacesUseCase(this.repository);

  Future<List<RepairServiceModel>> call(
    double lat,
    double lon,
    double radiusKm,
  ) async {
    return await repository.findMeetingPlacesNearby(lat, lon, radiusKm);
  }
}

