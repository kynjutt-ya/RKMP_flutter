import 'eco_impact_dto.dart';


abstract class EcoImpactDataSource {
  Future<EcoImpactDto> getImpactByUserId(String userId);
  Future<EcoImpactDto> updateImpact(EcoImpactDto impact);
  Future<List<EcoAchievementDto>> getAllAchievements();
}

class EcoImpactLocalDataSource implements EcoImpactDataSource {
  final Map<String, EcoImpactDto> _impacts = {};

  EcoImpactLocalDataSource() {
    _initializeData();
  }

  void _initializeData() {
    _impacts['default'] = EcoImpactDto(
      itemsDonated: 0,
      kgSaved: 0.0,
      co2Saved: 0.0,
      achievements: [
        EcoAchievementDto(
          id: 'first_gift',
          title: 'Первый шаг',
          description: 'Отдал первую вещь',
          icon: '🎁',
          targetValue: 1,
          currentValue: 0,
        ),
        EcoAchievementDto(
          id: 'eco_warrior',
          title: 'Эко-воин',
          description: 'Отдал 10 вещей',
          icon: '🌱',
          targetValue: 10,
          currentValue: 0,
        ),
      ],
    );
  }

  @override
  Future<EcoImpactDto> getImpactByUserId(String userId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _impacts[userId] ?? _impacts['default']!;
  }

  @override
  Future<EcoImpactDto> updateImpact(EcoImpactDto impact) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _impacts['default'] = impact;
    return impact;
  }

  @override
  Future<List<EcoAchievementDto>> getAllAchievements() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _impacts['default']?.achievements ?? [];
  }
}

