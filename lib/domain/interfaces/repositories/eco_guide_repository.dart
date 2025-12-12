import '../../../core/models/eco_tip_model.dart';
import '../../../core/models/recycling_point_model.dart';

abstract class EcoGuideRepository {
  Future<List<EcoTipModel>> getAllTips();
  Future<List<RecyclingPointModel>> getAllRecyclingPoints();
  Future<List<RecyclingPointModel>> getRecyclingPointsByType(String type);
}

