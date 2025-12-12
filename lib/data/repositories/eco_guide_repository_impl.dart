import '../../core/models/eco_tip_model.dart';
import '../../core/models/recycling_point_model.dart';
import '../../domain/interfaces/repositories/eco_guide_repository.dart';
import '../datasources/eco_guide/eco_guide_local_data_source.dart';
import '../datasources/eco_guide/eco_guide_mapper.dart';

class EcoGuideRepositoryImpl implements EcoGuideRepository {
  final EcoGuideDataSource dataSource;

  EcoGuideRepositoryImpl(this.dataSource);

  @override
  Future<List<EcoTipModel>> getAllTips() async {
    final dtos = await dataSource.getAllTips();
    return EcoGuideMapper.tipToModelList(dtos);
  }

  @override
  Future<List<RecyclingPointModel>> getAllRecyclingPoints() async {
    final dtos = await dataSource.getAllRecyclingPoints();
    return EcoGuideMapper.pointToModelList(dtos);
  }

  @override
  Future<List<RecyclingPointModel>> getRecyclingPointsByType(String type) async {
    final dtos = await dataSource.getRecyclingPointsByType(type);
    return EcoGuideMapper.pointToModelList(dtos);
  }
}

