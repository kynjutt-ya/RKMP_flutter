import '../../../data/datasources/remote/nominatim/nominatim_remote_data_source.dart';
import '../../../data/datasources/remote/nominatim/nominatim_mapper.dart';

class SearchObjectsByTypeUseCase {
  final NominatimRemoteDataSource dataSource;

  SearchObjectsByTypeUseCase(this.dataSource);

  Future<List<String>> call(String objectType, String location, {int limit = 10}) async {
    if (objectType.trim().isEmpty || location.trim().isEmpty) {
      return [];
    }
    final dtos = await dataSource.searchObjectsByType(objectType, location, limit: limit);
    return dtos.map((dto) => NominatimMapper.toFormattedAddress(dto)).toList();
  }
}

