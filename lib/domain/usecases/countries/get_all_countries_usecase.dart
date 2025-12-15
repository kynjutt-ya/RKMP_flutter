import '../../../data/datasources/remote/countries/countries_remote_data_source.dart';
import '../../../data/datasources/remote/countries/countries_mapper.dart';
import '../../../core/models/eco_tip_model.dart';

/// Use case для получения всех стран (REST Countries API)
class GetAllCountriesUseCase {
  final CountriesRemoteDataSource dataSource;

  GetAllCountriesUseCase(this.dataSource);

  Future<List<EcoTipModel>> call() async {
    final countries = await dataSource.getAllCountries();
    return CountriesMapper.toEcoTipList(countries);
  }
}

