import '../../../network/dio_client.dart';
import '../../../network/network_exceptions.dart';
import 'countries_dto.dart';

/// Remote data source для работы с REST Countries API
/// Используется для получения экологических данных о странах
/// Всего реализовано 5 сетевых запросов:
/// 1. getAllCountries - все страны
/// 2. getCountryByName - страна по имени
/// 3. getCountriesByRegion - страны по региону
/// 4. getCountriesBySubregion - страны по подрегиону
/// 5. getCountriesByCapital - страны по столице
abstract class CountriesRemoteDataSource {
  /// 1. Получить все страны
  Future<List<CountryDto>> getAllCountries();

  /// 2. Получить страну по имени
  Future<List<CountryDto>> getCountryByName(String name);

  /// 3. Получить страны по региону
  Future<List<CountryDto>> getCountriesByRegion(String region);

  /// 4. Получить страны по подрегиону
  Future<List<CountryDto>> getCountriesBySubregion(String subregion);

  /// 5. Получить страны по столице
  Future<List<CountryDto>> getCountriesByCapital(String capital);
}

class CountriesRemoteDataSourceImpl implements CountriesRemoteDataSource {
  final DioClient _dioClient;

  CountriesRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<CountryDto>> getAllCountries() async {
    try {
      final response = await _dioClient.get('/v3.1/all');
      
      if (response.data is List) {
        return (response.data as List)
            .map((json) => CountryDto.fromJson(json))
            .toList();
      }

      return [];
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Ошибка при получении списка стран: $e');
    }
  }

  @override
  Future<List<CountryDto>> getCountryByName(String name) async {
    try {
      final response = await _dioClient.get(
        '/v3.1/name/$name',
        queryParameters: {'fullText': 'false'},
      );

      if (response.data is List) {
        return (response.data as List)
            .map((json) => CountryDto.fromJson(json))
            .toList();
      }

      return [];
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Ошибка при поиске страны по имени: $e');
    }
  }

  @override
  Future<List<CountryDto>> getCountriesByRegion(String region) async {
    try {
      final response = await _dioClient.get('/v3.1/region/$region');

      if (response.data is List) {
        return (response.data as List)
            .map((json) => CountryDto.fromJson(json))
            .toList();
      }

      return [];
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Ошибка при поиске стран по региону: $e');
    }
  }

  @override
  Future<List<CountryDto>> getCountriesBySubregion(String subregion) async {
    try {
      final response = await _dioClient.get('/v3.1/subregion/$subregion');

      if (response.data is List) {
        return (response.data as List)
            .map((json) => CountryDto.fromJson(json))
            .toList();
      }

      return [];
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Ошибка при поиске стран по подрегиону: $e');
    }
  }

  @override
  Future<List<CountryDto>> getCountriesByCapital(String capital) async {
    try {
      final response = await _dioClient.get('/v3.1/capital/$capital');

      if (response.data is List) {
        return (response.data as List)
            .map((json) => CountryDto.fromJson(json))
            .toList();
      }

      return [];
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Ошибка при поиске стран по столице: $e');
    }
  }
}

