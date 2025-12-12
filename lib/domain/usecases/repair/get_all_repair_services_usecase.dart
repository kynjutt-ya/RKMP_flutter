import '../../../core/models/repair_service_model.dart';
import '../../interfaces/repositories/repair_repository.dart';

class GetAllRepairServicesUseCase {
  final RepairRepository repository;

  GetAllRepairServicesUseCase(this.repository);

  Future<List<RepairServiceModel>> call() async {
    return await repository.getAllServices();
  }
}

