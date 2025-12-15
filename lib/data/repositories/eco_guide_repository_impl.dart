import '../../core/models/eco_tip_model.dart';
import '../../core/models/recycling_point_model.dart';
import '../../domain/interfaces/repositories/eco_guide_repository.dart';
import '../datasources/eco_guide/eco_guide_local_data_source.dart';
import '../datasources/eco_guide/eco_guide_mapper.dart';
import '../datasources/remote/overpass/overpass_remote_data_source.dart';
import '../datasources/remote/overpass/overpass_mapper.dart';
import '../datasources/remote/wikipedia/wikipedia_remote_data_source.dart';
import '../datasources/remote/wikipedia/wikipedia_mapper.dart';

class EcoGuideRepositoryImpl implements EcoGuideRepository {
  final EcoGuideDataSource dataSource;
  final OverpassRemoteDataSource? overpassDataSource;
  final WikipediaRemoteDataSource? wikipediaDataSource;

  EcoGuideRepositoryImpl(
    this.dataSource, {
    this.overpassDataSource,
    this.wikipediaDataSource,
  });

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

  @override
  Future<List<RecyclingPointModel>> findRecyclingPointsNearby(
    double lat,
    double lon,
    double radiusKm,
  ) async {
    if (overpassDataSource == null) {
      return await getAllRecyclingPoints();
    }

    try {
      final elements = await overpassDataSource!.findRecyclingPoints(lat, lon, radiusKm);
      return OverpassMapper.toRecyclingPointList(elements);
    } catch (e) {
      print('⚠️ Ошибка при поиске пунктов приема через Overpass: $e');
      return await getAllRecyclingPoints();
    }
  }

  @override
  Future<List<RecyclingPointModel>> findSecondHandShopsNearby(
    double lat,
    double lon,
    double radiusKm,
  ) async {
    if (overpassDataSource == null) {
      return await getAllRecyclingPoints();
    }

    try {
      final elements = await overpassDataSource!.findSecondHandShops(lat, lon, radiusKm);
      return OverpassMapper.toRecyclingPointList(elements);
    } catch (e) {
      print('⚠️ Ошибка при поиске магазинов секонд-хенд через Overpass: $e');
      return await getAllRecyclingPoints();
    }
  }

  @override
  Future<List<RecyclingPointModel>> findClothingRecyclingPointsNearby(
    double lat,
    double lon,
    double radiusKm,
  ) async {
    if (overpassDataSource == null) {
      return await getAllRecyclingPoints();
    }

    try {
      final elements = await overpassDataSource!.findClothingRecyclingPoints(lat, lon, radiusKm);
      return OverpassMapper.toRecyclingPointList(elements);
    } catch (e) {
      print('⚠️ Ошибка при поиске пунктов приема одежды через Overpass: $e');
      return await getAllRecyclingPoints();
    }
  }

  // Wikipedia API методы (5 запросов)
  @override
  Future<List<EcoTipModel>> searchWikipediaArticles(String query, {int limit = 5}) async {
    if (wikipediaDataSource == null) {
      return [];
    }
    try {
      final results = await wikipediaDataSource!.searchArticles(query, limit: limit);
      return WikipediaMapper.searchResultsToEcoTips(results);
    } catch (e) {
      print('⚠️ Ошибка поиска статей Wikipedia: $e');
      return [];
    }
  }

  @override
  Future<EcoTipModel> getWikipediaPageContent(String title) async {
    if (wikipediaDataSource == null) {
      throw Exception('Wikipedia API не настроен');
    }
    try {
      final page = await wikipediaDataSource!.getPageContent(title);
      return WikipediaMapper.pageToEcoTip(page);
    } catch (e) {
      print('⚠️ Ошибка получения содержимого Wikipedia: $e');
      rethrow;
    }
  }

  @override
  Future<List<EcoTipModel>> getWikipediaCategoryArticles(String category, {int limit = 10}) async {
    if (wikipediaDataSource == null) {
      return [];
    }
    try {
      final members = await wikipediaDataSource!.getCategoryMembers(category, limit: limit);
      return WikipediaMapper.categoryMembersToEcoTips(members);
    } catch (e) {
      print('⚠️ Ошибка получения категории Wikipedia: $e');
      return [];
    }
  }

  @override
  Future<List<EcoTipModel>> getWikipediaPageLinks(String title, {int limit = 10}) async {
    if (wikipediaDataSource == null) {
      return [];
    }
    try {
      final links = await wikipediaDataSource!.getPageLinks(title, limit: limit);
      return WikipediaMapper.linksToEcoTips(links);
    } catch (e) {
      print('⚠️ Ошибка получения связанных статей Wikipedia: $e');
      return [];
    }
  }

  @override
  Future<List<EcoTipModel>> getWikipediaPageImages(String title, {int limit = 10}) async {
    if (wikipediaDataSource == null) {
      return [];
    }
    try {
      final images = await wikipediaDataSource!.getPageImages(title, limit: limit);
      return WikipediaMapper.imagesToEcoTips(images);
    } catch (e) {
      print('⚠️ Ошибка получения изображений Wikipedia: $e');
      return [];
    }
  }
}

