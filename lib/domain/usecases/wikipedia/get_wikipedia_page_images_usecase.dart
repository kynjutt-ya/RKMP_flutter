import '../../../core/models/eco_tip_model.dart';
import '../../interfaces/repositories/eco_guide_repository.dart';

class GetWikipediaPageImagesUseCase {
  final EcoGuideRepository repository;

  GetWikipediaPageImagesUseCase(this.repository);

  Future<List<EcoTipModel>> call(String title, {int limit = 10}) async {
    if (title.trim().isEmpty) {
      return [];
    }
    return await repository.getWikipediaPageImages(title, limit: limit);
  }
}

