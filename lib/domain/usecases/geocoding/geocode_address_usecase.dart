import '../../../data/datasources/remote/nominatim/nominatim_remote_data_source.dart';
import '../../../data/datasources/remote/nominatim/nominatim_mapper.dart';

class GeocodeAddressUseCase {
  final NominatimRemoteDataSource dataSource;

  GeocodeAddressUseCase(this.dataSource);

  Future<(double lat, double lon)> call(String address) async {
    if (address.trim().isEmpty) {
      throw Exception('Адрес не может быть пустым');
    }

    final dto = await dataSource.geocodeAddress(address);
    return NominatimMapper.toCoordinates(dto);
  }
}

