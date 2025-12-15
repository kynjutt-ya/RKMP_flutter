import '../../../../core/models/eco_tip_model.dart';
import 'wikipedia_dto.dart';

class WikipediaMapper {
  static EcoTipModel searchResultToEcoTip(WikipediaSearchResultDto dto, int index) {
    return EcoTipModel(
      id: 'wikipedia_${dto.pageId}_$index',
      title: dto.title,
      content: _cleanHtml(dto.snippet),
      createdAt: DateTime.now().subtract(Duration(days: index)),
    );
  }

  static EcoTipModel pageToEcoTip(WikipediaPageDto dto) {
    return EcoTipModel(
      id: 'wikipedia_page_${dto.pageId}',
      title: dto.title,
      content: _cleanHtml(dto.extract),
      imageUrl: dto.thumbnailUrl,
      createdAt: DateTime.now(),
    );
  }

  static EcoTipModel summaryToEcoTip(WikipediaSummaryDto dto) {
    return EcoTipModel(
      id: 'wikipedia_summary_${dto.title}',
      title: dto.title,
      content: _cleanHtml(dto.extract),
      imageUrl: dto.thumbnailUrl,
      createdAt: DateTime.now(),
    );
  }

  static EcoTipModel categoryMemberToEcoTip(WikipediaCategoryMemberDto dto, int index) {
    return EcoTipModel(
      id: 'wikipedia_category_${dto.pageId}_$index',
      title: dto.title,
      content: 'Статья из категории Wikipedia',
      createdAt: DateTime.now().subtract(Duration(days: index)),
    );
  }

  static String _cleanHtml(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'&[^;]+;'), '')
        .trim();
  }

  static List<EcoTipModel> searchResultsToEcoTips(List<WikipediaSearchResultDto> dtos) {
    return dtos.asMap().entries.map((entry) {
      return searchResultToEcoTip(entry.value, entry.key);
    }).toList();
  }

  static List<EcoTipModel> categoryMembersToEcoTips(List<WikipediaCategoryMemberDto> dtos) {
    return dtos.asMap().entries.map((entry) {
      return categoryMemberToEcoTip(entry.value, entry.key);
    }).toList();
  }

  static EcoTipModel linkToEcoTip(WikipediaLinkDto dto, int index) {
    return EcoTipModel(
      id: 'wikipedia_link_${dto.pageId}_$index',
      title: dto.title,
      content: 'Связанная статья: ${dto.title}',
      createdAt: DateTime.now().subtract(Duration(days: index)),
    );
  }

  static List<EcoTipModel> linksToEcoTips(List<WikipediaLinkDto> dtos) {
    return dtos.asMap().entries.map((entry) {
      return linkToEcoTip(entry.value, entry.key);
    }).toList();
  }

  static EcoTipModel imageToEcoTip(WikipediaImageDto dto, int index) {
    return EcoTipModel(
      id: 'wikipedia_image_${dto.title}_$index',
      title: dto.title.replaceAll('File:', '').replaceAll('Image:', ''),
      content: 'Изображение из статьи Wikipedia',
      imageUrl: dto.url,
      createdAt: DateTime.now().subtract(Duration(days: index)),
    );
  }

  static List<EcoTipModel> imagesToEcoTips(List<WikipediaImageDto> dtos) {
    return dtos.asMap().entries.map((entry) {
      return imageToEcoTip(entry.value, entry.key);
    }).toList();
  }
}

