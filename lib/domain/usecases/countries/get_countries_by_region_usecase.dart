import '../../../data/datasources/remote/countries/countries_remote_data_source.dart';
import '../../../data/datasources/remote/countries/countries_mapper.dart';
import '../../../core/models/eco_tip_model.dart';

/// Use case для получения стран по региону (REST Countries API)
class GetCountriesByRegionUseCase {
  final CountriesRemoteDataSource dataSource;

  GetCountriesByRegionUseCase(this.dataSource);

  Future<List<EcoTipModel>> call(String region) async {
    if (region.trim().isEmpty) {
      return [];
    }
    final countries = await dataSource.getCountriesByRegion(region);
    return CountriesMapper.toEcoTipList(countries);
  }
}

