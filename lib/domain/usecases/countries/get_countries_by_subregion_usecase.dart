import '../../../data/datasources/remote/countries/countries_remote_data_source.dart';
import '../../../data/datasources/remote/countries/countries_mapper.dart';
import '../../../core/models/eco_tip_model.dart';

/// Use case для получения стран по подрегиону (REST Countries API)
class GetCountriesBySubregionUseCase {
  final CountriesRemoteDataSource dataSource;

  GetCountriesBySubregionUseCase(this.dataSource);

  Future<List<EcoTipModel>> call(String subregion) async {
    if (subregion.trim().isEmpty) {
      return [];
    }
    final countries = await dataSource.getCountriesBySubregion(subregion);
    return CountriesMapper.toEcoTipList(countries);
  }
}

