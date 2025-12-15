import '../../../data/datasources/remote/nominatim/nominatim_remote_data_source.dart';
import '../../../data/datasources/remote/nominatim/nominatim_mapper.dart';

class SearchAddressesByCountryUseCase {
  final NominatimRemoteDataSource dataSource;

  SearchAddressesByCountryUseCase(this.dataSource);

  Future<List<String>> call(String query, String country, {int limit = 5}) async {
    if (query.trim().isEmpty || country.trim().isEmpty) {
      return [];
    }
    final dtos = await dataSource.searchAddressesByCountry(query, country, limit: limit);
    return dtos.map((dto) => NominatimMapper.toFormattedAddress(dto)).toList();
  }
}

