import '../../core/models/eco_impact_model.dart' show EcoImpactModel, EcoAchievementModel;
import '../../domain/interfaces/repositories/eco_impact_repository.dart';
import '../datasources/eco_impact/eco_impact_local_data_source.dart';
import '../datasources/eco_impact/eco_impact_mapper.dart';

class EcoImpactRepositoryImpl implements EcoImpactRepository {
  final EcoImpactDataSource dataSource;

  EcoImpactRepositoryImpl(this.dataSource);

  @override
  Future<EcoImpactModel> getImpactByUserId(String userId) async {
    final dto = await dataSource.getImpactByUserId(userId);
    return EcoImpactMapper.toModel(dto);
  }

  @override
  Future<EcoImpactModel> updateImpact(EcoImpactModel impact) async {
    final dto = EcoImpactMapper.toDto(impact);
    final updatedDto = await dataSource.updateImpact(dto);
    return EcoImpactMapper.toModel(updatedDto);
  }

  @override
  Future<List<EcoAchievementModel>> getAllAchievements() async {
    final dtos = await dataSource.getAllAchievements();
    return dtos.map((dto) => EcoAchievementModel(
      id: dto.id,
      title: dto.title,
      description: dto.description,
      icon: dto.icon,
      unlockedAt: dto.unlockedAt,
      targetValue: dto.targetValue,
      currentValue: dto.currentValue,
    )).toList();
  }
}

