import '../../../core/models/eco_tip_model.dart';
import '../../interfaces/repositories/eco_guide_repository.dart';

class GetWikipediaPageContentUseCase {
  final EcoGuideRepository repository;

  GetWikipediaPageContentUseCase(this.repository);

  Future<EcoTipModel> call(String title) async {
    if (title.trim().isEmpty) {
      throw Exception('Название статьи не может быть пустым');
    }
    return await repository.getWikipediaPageContent(title);
  }
}

