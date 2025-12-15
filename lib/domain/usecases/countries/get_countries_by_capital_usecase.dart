import '../../../data/datasources/remote/countries/countries_remote_data_source.dart';
import '../../../data/datasources/remote/countries/countries_mapper.dart';
import '../../../core/models/eco_tip_model.dart';

/// Use case для получения стран по столице (REST Countries API)
class GetCountriesByCapitalUseCase {
  final CountriesRemoteDataSource dataSource;

  GetCountriesByCapitalUseCase(this.dataSource);

  Future<List<EcoTipModel>> call(String capital) async {
    if (capital.trim().isEmpty) {
      return [];
    }
    final countries = await dataSource.getCountriesByCapital(capital);
    return CountriesMapper.toEcoTipList(countries);
  }
}

