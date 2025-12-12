import '../../../core/models/repair_service_model.dart';
import '../../interfaces/repositories/repair_repository.dart';

class GetServicesByCategoryUseCase {
  final RepairRepository repository;

  GetServicesByCategoryUseCase(this.repository);

  Future<List<RepairServiceModel>> call(String category) async {
    if (category.isEmpty) {
      return await repository.getAllServices();
    }
    return await repository.getServicesByCategory(category);
  }
}

