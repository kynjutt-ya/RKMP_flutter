import '../../../core/models/repair_service_model.dart';

abstract class RepairRepository {
  Future<List<RepairServiceModel>> getAllServices();
  Future<List<RepairServiceModel>> getServicesByCategory(String category);
  Future<RepairServiceModel?> getServiceById(String id);
  
  /// Поиск сервисов ремонта через Overpass API в радиусе
  Future<List<RepairServiceModel>> findRepairServicesNearby(
    double lat,
    double lon,
    double radiusKm,
  );

  /// Поиск мест для безопасных встреч через Overpass API
  Future<List<RepairServiceModel>> findMeetingPlacesNearby(
    double lat,
    double lon,
    double radiusKm,
  );
}

