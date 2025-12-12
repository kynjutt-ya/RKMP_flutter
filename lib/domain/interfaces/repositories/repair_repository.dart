import '../../../core/models/repair_service_model.dart';

abstract class RepairRepository {
  Future<List<RepairServiceModel>> getAllServices();
  Future<List<RepairServiceModel>> getServicesByCategory(String category);
  Future<RepairServiceModel?> getServiceById(String id);
}

