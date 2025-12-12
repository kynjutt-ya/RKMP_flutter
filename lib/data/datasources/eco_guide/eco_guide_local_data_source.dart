import 'eco_tip_dto.dart';
import 'recycling_point_dto.dart';

abstract class EcoGuideDataSource {
  Future<List<EcoTipDto>> getAllTips();
  Future<List<RecyclingPointDto>> getAllRecyclingPoints();
  Future<List<RecyclingPointDto>> getRecyclingPointsByType(String type);
}

class EcoGuideLocalDataSource implements EcoGuideDataSource {
  final List<EcoTipDto> _tips = [];
  final List<RecyclingPointDto> _points = [];

  EcoGuideLocalDataSource() {
    _initializeData();
  }

  void _initializeData() {
    _tips.addAll([
      EcoTipDto(
        id: '1',
        title: 'Сортируйте отходы',
        content: 'Разделяйте мусор на категории: бумага, пластик, стекло, металл.',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      EcoTipDto(
        id: '2',
        title: 'Используйте многоразовые сумки',
        content: 'Откажитесь от пластиковых пакетов в пользу тканевых сумок.',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ]);

    _points.addAll([
      RecyclingPointDto(
        id: '1',
        name: 'Эко-Пункт на Ленина',
        address: 'ул. Ленина, д. 10',
        phone: '+7 (495) 123-45-67',
        acceptedTypes: ['paper', 'plastic', 'glass'],
        latitude: 55.7558,
        longitude: 37.6173,
      ),
      RecyclingPointDto(
        id: '2',
        name: 'Приём электроники',
        address: 'ул. Мира, д. 25',
        phone: '+7 (495) 234-56-78',
        acceptedTypes: ['electronics', 'batteries'],
        latitude: 55.7512,
        longitude: 37.6184,
      ),
    ]);
  }

  @override
  Future<List<EcoTipDto>> getAllTips() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.from(_tips);
  }

  @override
  Future<List<RecyclingPointDto>> getAllRecyclingPoints() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.from(_points);
  }

  @override
  Future<List<RecyclingPointDto>> getRecyclingPointsByType(String type) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _points.where((p) => p.acceptedTypes.contains(type)).toList();
  }
}

