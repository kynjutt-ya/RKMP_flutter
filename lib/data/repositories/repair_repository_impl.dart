import '../../core/models/repair_service_model.dart';
import '../../domain/interfaces/repositories/repair_repository.dart';
import '../datasources/repair/repair_local_data_source.dart';
import '../datasources/repair/repair_service_mapper.dart';

class RepairRepositoryImpl implements RepairRepository {
  final RepairDataSource dataSource;

  RepairRepositoryImpl(this.dataSource);

  @override
  Future<List<RepairServiceModel>> getAllServices() async {
    final dtos = await dataSource.getAllServices();
    return RepairServiceMapper.toModelList(dtos);
  }

  @override
  Future<List<RepairServiceModel>> getServicesByCategory(String category) async {
    final dtos = await dataSource.getServicesByCategory(category);
    return RepairServiceMapper.toModelList(dtos);
  }

  @override
  Future<RepairServiceModel?> getServiceById(String id) async {
    final dto = await dataSource.getServiceById(id);
    return dto != null ? RepairServiceMapper.toModel(dto) : null;
  }
}

