import '../../../core/models/eco_impact_model.dart';
import 'eco_impact_dto.dart';

class EcoImpactMapper {
  static EcoImpactModel toModel(EcoImpactDto dto) {
    return EcoImpactModel(
      itemsDonated: dto.itemsDonated,
      kgSaved: dto.kgSaved,
      co2Saved: dto.co2Saved,
      achievements: dto.achievements.map((a) => _achievementToModel(a)).toList(),
    );
  }

  static EcoImpactDto toDto(EcoImpactModel model) {
    return EcoImpactDto(
      itemsDonated: model.itemsDonated,
      kgSaved: model.kgSaved,
      co2Saved: model.co2Saved,
      achievements: model.achievements.map((a) => _achievementToDto(a)).toList(),
    );
  }

  static EcoAchievementModel _achievementToModel(EcoAchievementDto dto) {
    return EcoAchievementModel(
      id: dto.id,
      title: dto.title,
      description: dto.description,
      icon: dto.icon,
      unlockedAt: dto.unlockedAt,
      targetValue: dto.targetValue,
      currentValue: dto.currentValue,
    );
  }

  static EcoAchievementDto _achievementToDto(EcoAchievementModel model) {
    return EcoAchievementDto(
      id: model.id,
      title: model.title,
      description: model.description,
      icon: model.icon,
      unlockedAt: model.unlockedAt,
      targetValue: model.targetValue,
      currentValue: model.currentValue,
    );
  }
}

