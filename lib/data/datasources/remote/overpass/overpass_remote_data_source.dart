import 'package:dio/dio.dart';
import '../../../network/dio_client.dart';
import '../../../network/network_exceptions.dart';
import 'overpass_dto.dart';

/// Remote data source для работы с Overpass API (OpenStreetMap)
/// Используется для поиска пунктов приема отходов и сервисов ремонта
/// Всего реализовано 5 сетевых запросов:
/// 1. findRecyclingPoints - пункты приема отходов
/// 2. findRepairServices - сервисы ремонта
/// 3. findSecondHandShops - магазины секонд-хенд
/// 4. findMeetingPlaces - места для встреч
/// 5. findClothingRecyclingPoints - пункты приема одежды
abstract class OverpassRemoteDataSource {
  /// 1. Поиск пунктов приема отходов в радиусе
  Future<List<OverpassElementDto>> findRecyclingPoints(
    double lat,
    double lon,
    double radiusKm,
  );

  /// 2. Поиск сервисов ремонта в радиусе
  Future<List<OverpassElementDto>> findRepairServices(
    double lat,
    double lon,
    double radiusKm,
  );

  /// 3. Поиск магазинов секонд-хенд и благотворительных магазинов
  Future<List<OverpassElementDto>> findSecondHandShops(
    double lat,
    double lon,
    double radiusKm,
  );

  /// 4. Поиск мест для безопасных встреч (кафе, парки)
  Future<List<OverpassElementDto>> findMeetingPlaces(
    double lat,
    double lon,
    double radiusKm,
  );

  /// 5. Поиск пунктов приема одежды и текстиля
  Future<List<OverpassElementDto>> findClothingRecyclingPoints(
    double lat,
    double lon,
    double radiusKm,
  );
}

class OverpassRemoteDataSourceImpl implements OverpassRemoteDataSource {
  final DioClient _dioClient;

  OverpassRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<OverpassElementDto>> findRecyclingPoints(
    double lat,
    double lon,
    double radiusKm,
  ) async {
    try {
      // Overpass QL запрос для поиска пунктов приема отходов
      final query = '''
[out:json][timeout:25];
(
  node["amenity"="recycling"](around:${(radiusKm * 1000).toInt()},$lat,$lon);
  node["recycling:*"](around:${(radiusKm * 1000).toInt()},$lat,$lon);
  way["amenity"="recycling"](around:${(radiusKm * 1000).toInt()},$lat,$lon);
  way["recycling:*"](around:${(radiusKm * 1000).toInt()},$lat,$lon);
);
out center;
''';

      final response = await _dioClient.post(
        '/interpreter',
        data: query,
        options: Options(
          headers: {'Content-Type': 'text/plain'},
          responseType: ResponseType.json,
        ),
      );

      if (response.data is Map && response.data['elements'] != null) {
        final overpassResponse = OverpassResponseDto.fromJson(response.data);
        // Фильтруем только элементы с координатами
        return overpassResponse.elements.where((e) {
          // Для way элементов координаты могут быть в центре
          return e.latitude != 0.0 && e.longitude != 0.0;
        }).toList();
      }

      return [];
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Ошибка при поиске пунктов приема: $e');
    }
  }

  @override
  Future<List<OverpassElementDto>> findRepairServices(
    double lat,
    double lon,
    double radiusKm,
  ) async {
    try {
      // Overpass QL запрос для поиска сервисов ремонта
      final query = '''
[out:json][timeout:25];
(
  node["shop"="repair"](around:${(radiusKm * 1000).toInt()},$lat,$lon);
  node["craft"="repair"](around:${(radiusKm * 1000).toInt()},$lat,$lon);
  way["shop"="repair"](around:${(radiusKm * 1000).toInt()},$lat,$lon);
  way["craft"="repair"](around:${(radiusKm * 1000).toInt()},$lat,$lon);
);
out center;
''';

      final response = await _dioClient.post(
        '/interpreter',
        data: query,
        options: Options(
          headers: {'Content-Type': 'text/plain'},
          responseType: ResponseType.json,
        ),
      );

      if (response.data is Map && response.data['elements'] != null) {
        final overpassResponse = OverpassResponseDto.fromJson(response.data);
        // Фильтруем только элементы с координатами
        return overpassResponse.elements.where((e) {
          // Для way элементов координаты могут быть в центре
          return e.latitude != 0.0 && e.longitude != 0.0;
        }).toList();
      }

      return [];
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Ошибка при поиске сервисов ремонта: $e');
    }
  }

  @override
  Future<List<OverpassElementDto>> findSecondHandShops(
    double lat,
    double lon,
    double radiusKm,
  ) async {
    try {
      // Overpass QL запрос для поиска магазинов секонд-хенд
      final query = '''
[out:json][timeout:25];
(
  node["shop"="second_hand"](around:${(radiusKm * 1000).toInt()},$lat,$lon);
  node["shop"="charity"](around:${(radiusKm * 1000).toInt()},$lat,$lon);
  way["shop"="second_hand"](around:${(radiusKm * 1000).toInt()},$lat,$lon);
  way["shop"="charity"](around:${(radiusKm * 1000).toInt()},$lat,$lon);
);
out center;
''';

      final response = await _dioClient.post(
        '/interpreter',
        data: query,
        options: Options(
          headers: {'Content-Type': 'text/plain'},
          responseType: ResponseType.json,
        ),
      );

      if (response.data is Map && response.data['elements'] != null) {
        final overpassResponse = OverpassResponseDto.fromJson(response.data);
        return overpassResponse.elements.where((e) {
          return e.latitude != 0.0 && e.longitude != 0.0;
        }).toList();
      }

      return [];
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Ошибка при поиске магазинов секонд-хенд: $e');
    }
  }

  @override
  Future<List<OverpassElementDto>> findMeetingPlaces(
    double lat,
    double lon,
    double radiusKm,
  ) async {
    try {
      // Overpass QL запрос для поиска мест для встреч (кафе, парки)
      final query = '''
[out:json][timeout:25];
(
  node["amenity"="cafe"](around:${(radiusKm * 1000).toInt()},$lat,$lon);
  node["amenity"="restaurant"](around:${(radiusKm * 1000).toInt()},$lat,$lon);
  node["leisure"="park"](around:${(radiusKm * 1000).toInt()},$lat,$lon);
  way["amenity"="cafe"](around:${(radiusKm * 1000).toInt()},$lat,$lon);
  way["amenity"="restaurant"](around:${(radiusKm * 1000).toInt()},$lat,$lon);
  way["leisure"="park"](around:${(radiusKm * 1000).toInt()},$lat,$lon);
);
out center;
''';

      final response = await _dioClient.post(
        '/interpreter',
        data: query,
        options: Options(
          headers: {'Content-Type': 'text/plain'},
          responseType: ResponseType.json,
        ),
      );

      if (response.data is Map && response.data['elements'] != null) {
        final overpassResponse = OverpassResponseDto.fromJson(response.data);
        return overpassResponse.elements.where((e) {
          return e.latitude != 0.0 && e.longitude != 0.0;
        }).toList();
      }

      return [];
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Ошибка при поиске мест для встреч: $e');
    }
  }

  @override
  Future<List<OverpassElementDto>> findClothingRecyclingPoints(
    double lat,
    double lon,
    double radiusKm,
  ) async {
    try {
      // Overpass QL запрос для поиска пунктов приема одежды
      final query = '''
[out:json][timeout:25];
(
  node["recycling:clothes"="yes"](around:${(radiusKm * 1000).toInt()},$lat,$lon);
  node["recycling:textiles"="yes"](around:${(radiusKm * 1000).toInt()},$lat,$lon);
  way["recycling:clothes"="yes"](around:${(radiusKm * 1000).toInt()},$lat,$lon);
  way["recycling:textiles"="yes"](around:${(radiusKm * 1000).toInt()},$lat,$lon);
);
out center;
''';

      final response = await _dioClient.post(
        '/interpreter',
        data: query,
        options: Options(
          headers: {'Content-Type': 'text/plain'},
          responseType: ResponseType.json,
        ),
      );

      if (response.data is Map && response.data['elements'] != null) {
        final overpassResponse = OverpassResponseDto.fromJson(response.data);
        return overpassResponse.elements.where((e) {
          return e.latitude != 0.0 && e.longitude != 0.0;
        }).toList();
      }

      return [];
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Ошибка при поиске пунктов приема одежды: $e');
    }
  }
}

