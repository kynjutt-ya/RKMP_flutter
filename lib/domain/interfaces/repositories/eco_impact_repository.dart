import '../../../core/models/eco_impact_model.dart';

abstract class EcoImpactRepository {
  Future<EcoImpactModel> getImpactByUserId(String userId);
  Future<EcoImpactModel> updateImpact(EcoImpactModel impact);
  Future<List<EcoAchievementModel>> getAllAchievements();
}

