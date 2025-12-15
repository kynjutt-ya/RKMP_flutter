import '../../../data/datasources/remote/nominatim/nominatim_remote_data_source.dart';
import '../../../data/datasources/remote/nominatim/nominatim_mapper.dart';

class SearchAddressesInCityUseCase {
  final NominatimRemoteDataSource dataSource;

  SearchAddressesInCityUseCase(this.dataSource);

  Future<List<String>> call(String query, String city, {int limit = 5}) async {
    if (query.trim().isEmpty || city.trim().isEmpty) {
      return [];
    }

    final dtos = await dataSource.searchAddressesInCity(query, city, limit: limit);
    return dtos.map((dto) => NominatimMapper.toAddressString(dto)).toList();
  }
}

