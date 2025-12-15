import '../../core/models/repair_service_model.dart';
import '../../domain/interfaces/repositories/repair_repository.dart';
import '../datasources/repair/repair_local_data_source.dart';
import '../datasources/repair/repair_service_mapper.dart';
import '../datasources/remote/overpass/overpass_remote_data_source.dart';
import '../datasources/remote/overpass/overpass_mapper.dart';

class RepairRepositoryImpl implements RepairRepository {
  final RepairDataSource dataSource;
  final OverpassRemoteDataSource? overpassDataSource;

  RepairRepositoryImpl(this.dataSource, {this.overpassDataSource});

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

  @override
  Future<List<RepairServiceModel>> findRepairServicesNearby(
    double lat,
    double lon,
    double radiusKm,
  ) async {
    if (overpassDataSource == null) {
      // Fallback на локальные данные, если сетевой источник недоступен
      return await getAllServices();
    }

    try {
      final elements = await overpassDataSource!.findRepairServices(lat, lon, radiusKm);
      return OverpassMapper.toRepairServiceList(elements);
    } catch (e) {
      // В случае ошибки возвращаем локальные данные
      print('⚠️ Ошибка при поиске сервисов ремонта через Overpass: $e');
      return await getAllServices();
    }
  }

  @override
  Future<List<RepairServiceModel>> findMeetingPlacesNearby(
    double lat,
    double lon,
    double radiusKm,
  ) async {
    if (overpassDataSource == null) {
      return await getAllServices();
    }

    try {
      final elements = await overpassDataSource!.findMeetingPlaces(lat, lon, radiusKm);
      return OverpassMapper.toRepairServiceList(elements);
    } catch (e) {
      print('⚠️ Ошибка при поиске мест для встреч через Overpass: $e');
      return await getAllServices();
    }
  }
}

