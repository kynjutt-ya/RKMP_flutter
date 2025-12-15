import '../../../core/models/eco_tip_model.dart';
import '../../interfaces/repositories/eco_guide_repository.dart';

class GetWikipediaCategoryArticlesUseCase {
  final EcoGuideRepository repository;

  GetWikipediaCategoryArticlesUseCase(this.repository);

  Future<List<EcoTipModel>> call(String category, {int limit = 10}) async {
    if (category.trim().isEmpty) {
      return [];
    }
    return await repository.getWikipediaCategoryArticles(category, limit: limit);
  }
}

