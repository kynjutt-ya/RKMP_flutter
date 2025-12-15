import '../../../core/models/eco_tip_model.dart';
import '../../interfaces/repositories/eco_guide_repository.dart';

class SearchWikipediaArticlesUseCase {
  final EcoGuideRepository repository;

  SearchWikipediaArticlesUseCase(this.repository);

  Future<List<EcoTipModel>> call(String query, {int limit = 5}) async {
    if (query.trim().isEmpty) {
      return [];
    }
    return await repository.searchWikipediaArticles(query, limit: limit);
  }
}

