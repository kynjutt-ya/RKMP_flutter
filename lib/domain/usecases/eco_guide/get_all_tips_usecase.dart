import '../../../core/models/eco_tip_model.dart';
import '../../interfaces/repositories/eco_guide_repository.dart';

class GetAllTipsUseCase {
  final EcoGuideRepository repository;

  GetAllTipsUseCase(this.repository);

  Future<List<EcoTipModel>> call() async {
    return await repository.getAllTips();
  }
}

