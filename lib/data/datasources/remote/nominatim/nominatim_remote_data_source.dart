import '../../../network/dio_client.dart';
import '../../../network/network_exceptions.dart';
import 'nominatim_dto.dart';


abstract class NominatimRemoteDataSource {

  Future<NominatimResponseDto> geocodeAddress(String address);

  Future<List<NominatimResponseDto>> searchAddresses(String query, {int limit = 5});

  Future<List<NominatimResponseDto>> searchAddressesInCity(String query, String city, {int limit = 5});

  Future<List<NominatimResponseDto>> searchAddressesByCountry(String query, String country, {int limit = 5});

  Future<List<NominatimResponseDto>> searchObjectsByType(String objectType, String location, {int limit = 10});
}

class NominatimRemoteDataSourceImpl implements NominatimRemoteDataSource {
  final DioClient _dioClient;

  NominatimRemoteDataSourceImpl(this._dioClient);

  @override
  Future<NominatimResponseDto> geocodeAddress(String address) async {
    try {
      print('🌐 Nominatim: Прямой геокодинг адреса "$address"');
      final response = await _dioClient.get(
        '/search',
        queryParameters: {
          'q': address,
          'format': 'json',
          'limit': 1,
        },
      );

      if (response.data is List && (response.data as List).isNotEmpty) {
        final result = NominatimResponseDto.fromJson(response.data[0]);
        print('✅ Nominatim: Адрес геокодирован: ${result.displayName} (${result.lat}, ${result.lon})');
        return result;
      }

      print('⚠️ Nominatim: Адрес не найден для "$address"');
      throw NotFoundException('Адрес не найден');
    } on NetworkException {
      rethrow;
    } catch (e) {
      print('❌ Ошибка при геокодинге адреса: $e');
      throw NetworkException('Ошибка при геокодинге адреса: $e');
    }
  }

  @override
  Future<List<NominatimResponseDto>> searchAddressesByCountry(String query, String country, {int limit = 5}) async {
    try {
      final searchQuery = '$query, $country';
      print('🌐 Nominatim: Поиск адресов в стране "$country" по запросу "$query"');
      
      final response = await _dioClient.get(
        '/search',
        queryParameters: {
          'q': searchQuery,
          'format': 'json',
          'limit': limit,
          'addressdetails': 1,
        },
      );

      if (response.data is List) {
        final results = (response.data as List)
            .map((json) => NominatimResponseDto.fromJson(json))
            .toList();
        print('✅ Nominatim: Найдено ${results.length} адресов в стране "$country"');
        return results;
      }

      print('⚠️ Nominatim: Пустой ответ для "$searchQuery"');
      return [];
    } on NetworkException {
      rethrow;
    } catch (e) {
      print('❌ Nominatim: Ошибка при поиске адресов в стране: $e');
      throw NetworkException('Ошибка при поиске адресов в стране: $e');
    }
  }

  @override
  Future<List<NominatimResponseDto>> searchAddresses(String query, {int limit = 5}) async {
    try {
      print('🌐 Nominatim: Поиск адресов по запросу "$query"');
      final response = await _dioClient.get(
        '/search',
        queryParameters: {
          'q': query,
          'format': 'json',
          'limit': limit,
        },
      );

      if (response.data is List) {
        final results = (response.data as List)
            .map((json) => NominatimResponseDto.fromJson(json))
            .toList();
        print('✅ Nominatim: Найдено ${results.length} адресов для "$query"');
        return results;
      }

      print('⚠️ Nominatim: Пустой ответ для "$query"');
      return [];
    } on NetworkException {
      rethrow;
    } catch (e) {
      print('❌ Nominatim: Ошибка при поиске адресов: $e');
      throw NetworkException('Ошибка при поиске адресов: $e');
    }
  }

  @override
  Future<List<NominatimResponseDto>> searchAddressesInCity(String query, String city, {int limit = 5}) async {
    try {
      final searchQuery = '$query, $city';
      print('🌐 Nominatim: Поиск адресов в городе "$city" по запросу "$query"');
      
      final response = await _dioClient.get(
        '/search',
        queryParameters: {
          'q': searchQuery,
          'format': 'json',
          'limit': limit,
          'addressdetails': 1,
        },
      );

      if (response.data is List) {
        final results = (response.data as List)
            .map((json) => NominatimResponseDto.fromJson(json))
            .toList();
        print('✅ Nominatim: Найдено ${results.length} адресов в городе "$city"');
        return results;
      }

      print('⚠️ Nominatim: Пустой ответ для "$searchQuery"');
      return [];
    } on NetworkException {
      rethrow;
    } catch (e) {
      print('❌ Nominatim: Ошибка при поиске адресов в городе: $e');
      throw NetworkException('Ошибка при поиске адресов в городе: $e');
    }
  }

  @override
  Future<List<NominatimResponseDto>> searchObjectsByType(String objectType, String location, {int limit = 10}) async {
    try {
      final objectTypeMap = {
        'магазин': 'shop',
        'переработка': 'recycling',
        'пункт приема': 'recycling',
        'магазин секонд-хенд': 'second hand shop',
        'секонд-хенд': 'second hand',
        'ремонт': 'repair',
        'сервис': 'service',
        'кафе': 'cafe',
        'ресторан': 'restaurant',
      };

      final englishType = objectTypeMap[objectType.toLowerCase().trim()] ?? objectType.trim();

      final searchQuery = '$englishType $location';
      
      print('🌐 Nominatim: Поиск объектов типа "$objectType" (en: "$englishType") в "$location"');
      
      final response = await _dioClient.get(
        '/search',
        queryParameters: {
          'q': searchQuery,
          'format': 'json',
          'limit': limit,
          'addressdetails': 1,
        },
      );

      if (response.data is List) {
        final results = (response.data as List)
            .map((json) => NominatimResponseDto.fromJson(json))
            .toList();
        print('✅ Nominatim: Найдено ${results.length} объектов типа "$objectType" в "$location"');
        return results;
      }

      print('⚠️ Nominatim: Пустой ответ для "$searchQuery"');
      return [];
    } on NetworkException {
      rethrow;
    } catch (e) {
      print('❌ Nominatim: Ошибка при поиске объектов по типу: $e');
      throw NetworkException('Ошибка при поиске объектов по типу: $e');
    }
  }
}

