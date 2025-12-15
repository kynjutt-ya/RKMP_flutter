import '../../../../core/models/recycling_point_model.dart';
import '../../../../core/models/repair_service_model.dart';
import 'overpass_dto.dart';

/// Mapper для преобразования Overpass DTO в модели
class OverpassMapper {
  /// Преобразует OverpassElementDto в RecyclingPointModel
  static RecyclingPointModel toRecyclingPoint(OverpassElementDto dto) {
    final tags = dto.tags ?? {};
    final name = tags['name'] as String? ?? 
                 tags['operator'] as String? ?? 
                 'Пункт приема отходов';
    
    // Определяем типы принимаемых отходов из тегов
    final acceptedTypes = <String>[];
    if (tags['recycling:paper'] == 'yes') acceptedTypes.add('paper');
    if (tags['recycling:plastic'] == 'yes') acceptedTypes.add('plastic');
    if (tags['recycling:glass'] == 'yes') acceptedTypes.add('glass');
    if (tags['recycling:metal'] == 'yes') acceptedTypes.add('metal');
    if (tags['recycling:electronics'] == 'yes') acceptedTypes.add('electronics');
    if (tags['recycling:batteries'] == 'yes') acceptedTypes.add('batteries');
    
    // Если нет конкретных типов, добавляем общий
    if (acceptedTypes.isEmpty) {
      acceptedTypes.add('general');
    }

    final address = tags['addr:street'] as String? ?? 
                    tags['addr:full'] as String? ?? 
                    'Адрес не указан';
    
    final phone = tags['phone'] as String? ?? 
                  tags['contact:phone'] as String? ?? 
                  'Контакт не указан';
    
    return RecyclingPointModel(
      id: 'overpass_${dto.id}',
      name: name,
      address: address,
      latitude: dto.latitude,
      longitude: dto.longitude,
      acceptedTypes: acceptedTypes,
      phone: phone,
    );
  }

  /// Преобразует OverpassElementDto в RepairServiceModel
  static RepairServiceModel toRepairService(OverpassElementDto dto) {
    final tags = dto.tags ?? {};
    final name = tags['name'] as String? ?? 
                 tags['operator'] as String? ?? 
                 'Сервис ремонта';
    
    // Определяем категорию из тегов
    String category = 'other';
    if (tags['craft'] == 'repair' || tags['shop'] == 'repair') {
      // Пытаемся определить более конкретную категорию
      if (tags['repair'] == 'furniture' || tags['craft'] == 'carpenter') {
        category = 'furniture';
      } else if (tags['repair'] == 'electronics' || tags['craft'] == 'electronics_repair') {
        category = 'electronics';
      } else if (tags['repair'] == 'textile' || tags['craft'] == 'tailor') {
        category = 'textile';
      }
    }

    return RepairServiceModel(
      id: 'overpass_${dto.id}',
      name: name,
      category: category,
      description: tags['description'] as String? ?? 
                   tags['note'] as String? ?? 
                   'Сервис ремонта',
      priceFrom: 0.0, // Overpass не предоставляет информацию о ценах
      rating: 0.0, // Overpass не предоставляет информацию о рейтингах
      contact: tags['phone'] as String? ?? 
               tags['contact:phone'] as String? ?? 
               'Контакт не указан',
    );
  }

  /// Преобразует список OverpassElementDto в список RecyclingPointModel
  static List<RecyclingPointModel> toRecyclingPointList(List<OverpassElementDto> dtos) {
    return dtos.map((dto) => toRecyclingPoint(dto)).toList();
  }

  /// Преобразует список OverpassElementDto в список RepairServiceModel
  static List<RepairServiceModel> toRepairServiceList(List<OverpassElementDto> dtos) {
    return dtos.map((dto) => toRepairService(dto)).toList();
  }
}

