import '../../../data/datasources/remote/nominatim/nominatim_remote_data_source.dart';
import '../../../data/datasources/remote/nominatim/nominatim_mapper.dart';

class SearchAddressesUseCase {
  final NominatimRemoteDataSource dataSource;

  SearchAddressesUseCase(this.dataSource);

  Future<List<String>> call(String query, {int limit = 5}) async {
    if (query.trim().isEmpty) {
      return [];
    }

    final dtos = await dataSource.searchAddresses(query, limit: limit);
    return dtos.map((dto) => NominatimMapper.toAddressString(dto)).toList();
  }
}

