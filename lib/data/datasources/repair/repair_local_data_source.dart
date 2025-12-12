import 'repair_service_dto.dart';

abstract class RepairDataSource {
  Future<List<RepairServiceDto>> getAllServices();
  Future<List<RepairServiceDto>> getServicesByCategory(String category);
  Future<RepairServiceDto?> getServiceById(String id);
}

class RepairLocalDataSource implements RepairDataSource {
  final List<RepairServiceDto> _services = [];

  RepairLocalDataSource() {
    _initializeData();
  }

  void _initializeData() {
    _services.addAll([
      RepairServiceDto(
        id: '1',
        name: 'Мастер по мебели Иван',
        category: 'furniture',
        description: 'Ремонт и реставрация мебели. Опыт 10 лет.',
        priceFrom: 1000.0,
        rating: 4.8,
        contact: '+7 (495) 111-22-33',
      ),
      RepairServiceDto(
        id: '2',
        name: 'Электро-Сервис',
        category: 'electronics',
        description: 'Ремонт бытовой техники и электроники.',
        priceFrom: 500.0,
        rating: 4.5,
        contact: '+7 (495) 222-33-44',
      ),
      RepairServiceDto(
        id: '3',
        name: 'Ателье "Шитьё и ремонт"',
        category: 'textile',
        description: 'Ремонт одежды, перешивка, апсайклинг.',
        priceFrom: 300.0,
        rating: 4.9,
        contact: '+7 (495) 333-44-55',
      ),
    ]);
  }

  @override
  Future<List<RepairServiceDto>> getAllServices() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.from(_services);
  }

  @override
  Future<List<RepairServiceDto>> getServicesByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _services.where((s) => s.category == category).toList();
  }

  @override
  Future<RepairServiceDto?> getServiceById(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    try {
      return _services.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }
}

