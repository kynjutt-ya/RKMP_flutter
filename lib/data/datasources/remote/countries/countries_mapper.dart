import '../../../../core/models/eco_tip_model.dart';
import 'countries_dto.dart';

/// Mapper для преобразования Countries DTO в экологические советы
/// Используем данные о странах для создания экологических советов
class CountriesMapper {
  /// Преобразует данные о стране в экологический совет
  static EcoTipModel toEcoTip(CountryDto dto, int index) {
    final tips = [
      '${dto.name} активно развивает экологические программы',
      'В ${dto.name} реализуются проекты по переработке отходов',
      '${dto.name} поддерживает международные экологические инициативы',
      'В ${dto.name} развивается возобновляемая энергетика',
      '${dto.name} участвует в программах по сокращению выбросов CO2',
    ];
    
    return EcoTipModel(
      id: 'country_${dto.name}_$index',
      title: 'Экология в ${dto.name}',
      content: tips[index % tips.length],
      createdAt: DateTime.now().subtract(Duration(days: index)),
    );
  }

  /// Преобразует список стран в список экологических советов
  static List<EcoTipModel> toEcoTipList(List<CountryDto> dtos) {
    return dtos.asMap().entries.map((entry) {
      return toEcoTip(entry.value, entry.key);
    }).toList();
  }
}

