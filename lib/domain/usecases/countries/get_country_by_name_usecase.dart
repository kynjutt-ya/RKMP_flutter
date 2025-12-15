import '../../../data/datasources/remote/countries/countries_remote_data_source.dart';
import '../../../data/datasources/remote/countries/countries_mapper.dart';
import '../../../core/models/eco_tip_model.dart';

/// Use case для поиска страны по имени (REST Countries API)
class GetCountryByNameUseCase {
  final CountriesRemoteDataSource dataSource;

  GetCountryByNameUseCase(this.dataSource);

  Future<List<EcoTipModel>> call(String name) async {
    if (name.trim().isEmpty) {
      return [];
    }
    final countries = await dataSource.getCountryByName(name);
    return CountriesMapper.toEcoTipList(countries);
  }
}

