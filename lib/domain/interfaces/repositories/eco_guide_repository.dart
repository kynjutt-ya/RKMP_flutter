import '../../../core/models/eco_tip_model.dart';
import '../../../core/models/recycling_point_model.dart';

abstract class EcoGuideRepository {
  Future<List<EcoTipModel>> getAllTips();
  Future<List<RecyclingPointModel>> getAllRecyclingPoints();
  Future<List<RecyclingPointModel>> getRecyclingPointsByType(String type);
  
  /// Поиск пунктов приема отходов через Overpass API в радиусе
  Future<List<RecyclingPointModel>> findRecyclingPointsNearby(
    double lat,
    double lon,
    double radiusKm,
  );

  /// Поиск магазинов секонд-хенд через Overpass API
  Future<List<RecyclingPointModel>> findSecondHandShopsNearby(
    double lat,
    double lon,
    double radiusKm,
  );

  /// Поиск пунктов приема одежды через Overpass API
  Future<List<RecyclingPointModel>> findClothingRecyclingPointsNearby(
    double lat,
    double lon,
    double radiusKm,
  );

  // Wikipedia API методы (5 запросов)
  /// 1. Поиск статей по запросу
  Future<List<EcoTipModel>> searchWikipediaArticles(String query, {int limit = 5});

  /// 2. Получение содержимого статьи
  Future<EcoTipModel> getWikipediaPageContent(String title);

  /// 3. Получение статей из категории
  Future<List<EcoTipModel>> getWikipediaCategoryArticles(String category, {int limit = 10});

  /// 4. Получение связанных статей (статей, на которые ссылается указанная статья)
  Future<List<EcoTipModel>> getWikipediaPageLinks(String title, {int limit = 10});

  /// 5. Получение изображений статьи
  Future<List<EcoTipModel>> getWikipediaPageImages(String title, {int limit = 10});
}

