// lib/features/eco_guide/cubit/eco_guide_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/interfaces/repositories/eco_guide_repository.dart';
import '../../../../domain/usecases/countries/get_all_countries_usecase.dart';
import '../../../../domain/usecases/countries/get_country_by_name_usecase.dart';
import '../../../../domain/usecases/countries/get_countries_by_region_usecase.dart';
import '../../../../domain/usecases/countries/get_countries_by_subregion_usecase.dart';
import '../../../../domain/usecases/countries/get_countries_by_capital_usecase.dart';
import '../../../../domain/usecases/wikipedia/search_wikipedia_articles_usecase.dart';
import '../../../../domain/usecases/wikipedia/get_wikipedia_page_content_usecase.dart';
import '../../../../domain/usecases/wikipedia/get_wikipedia_category_articles_usecase.dart';
import '../../../../domain/usecases/wikipedia/get_wikipedia_page_links_usecase.dart';
import '../../../../domain/usecases/wikipedia/get_wikipedia_page_images_usecase.dart';

class EcoTip {
  final String id;
  final String title;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;

  EcoTip({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class RecyclingPoint {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final List<String> acceptedTypes;
  final String? phone;
  final String? website;

  RecyclingPoint({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.acceptedTypes,
    this.phone,
    this.website,
  });
}

class EcoGuideCubit extends Cubit<EcoGuideState> {
  final EcoGuideRepository? repository;
  final GetAllCountriesUseCase? getAllCountriesUseCase;
  final GetCountryByNameUseCase? getCountryByNameUseCase;
  final GetCountriesByRegionUseCase? getCountriesByRegionUseCase;
  final GetCountriesBySubregionUseCase? getCountriesBySubregionUseCase;
  final GetCountriesByCapitalUseCase? getCountriesByCapitalUseCase;
  final SearchWikipediaArticlesUseCase? searchWikipediaArticlesUseCase;
  final GetWikipediaPageContentUseCase? getWikipediaPageContentUseCase;
  final GetWikipediaCategoryArticlesUseCase? getWikipediaCategoryArticlesUseCase;
  final GetWikipediaPageLinksUseCase? getWikipediaPageLinksUseCase;
  final GetWikipediaPageImagesUseCase? getWikipediaPageImagesUseCase;

  EcoGuideCubit({
    this.repository,
    this.getAllCountriesUseCase,
    this.getCountryByNameUseCase,
    this.getCountriesByRegionUseCase,
    this.getCountriesBySubregionUseCase,
    this.getCountriesByCapitalUseCase,
    this.searchWikipediaArticlesUseCase,
    this.getWikipediaPageContentUseCase,
    this.getWikipediaCategoryArticlesUseCase,
    this.getWikipediaPageLinksUseCase,
    this.getWikipediaPageImagesUseCase,
  }) : super(const EcoGuideState()) {
    loadTips();
    loadRecyclingPoints();
  }

  void setCategory(String category) {
    emit(state.copyWith(selectedCategory: category));
  }

  void loadTips() {
    // В реальном приложении здесь будет загрузка с сервера
    final tips = [
      EcoTip(
        id: '1',
        title: 'Раздельный сбор мусора',
        content: 'Начните с разделения отходов на категории: бумага, пластик, стекло, металл.',
      ),
      EcoTip(
        id: '2',
        title: 'Переработка электроники',
        content: 'Старую технику можно сдать в специальные пункты приёма. Они извлекают ценные материалы.',
      ),
      EcoTip(
        id: '3',
        title: 'Компостирование органики',
        content: 'Пищевые отходы можно компостировать дома или сдавать в компостные центры.',
      ),
      EcoTip(
        id: '4',
        title: 'Повторное использование',
        content: 'Прежде чем выбросить вещь, подумайте: можно ли её отдать, продать или переработать?',
      ),
    ];
    emit(state.copyWith(tipsList: tips));
  }


  // REST Countries API запросы (5 запросов)
  Future<void> loadCountriesFromAPI() async {
    if (getAllCountriesUseCase == null) {
      emit(state.copyWith(error: 'Сетевой запрос недоступен'));
      return;
    }

    try {
      emit(state.copyWith(isLoading: true, error: null));
      final tipsModels = await getAllCountriesUseCase!();
      // Конвертируем EcoTipModel в EcoTip для UI
      final tips = tipsModels.map((model) => EcoTip(
        id: model.id,
        title: model.title,
        content: model.content,
        imageUrl: model.imageUrl,
        createdAt: model.createdAt,
      )).toList();
      emit(state.copyWith(
        tipsList: tips,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: 'Ошибка при загрузке данных о странах: $e',
        isLoading: false,
      ));
    }
  }

  Future<void> searchCountryByName(String name) async {
    if (getCountryByNameUseCase == null) return;
    try {
      emit(state.copyWith(isLoading: true));
      final tipsModels = await getCountryByNameUseCase!(name);
      final tips = tipsModels.map((model) => EcoTip(
        id: model.id,
        title: model.title,
        content: model.content,
        imageUrl: model.imageUrl,
        createdAt: model.createdAt,
      )).toList();
      emit(state.copyWith(
        tipsList: tips,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: 'Ошибка при поиске страны: $e',
        isLoading: false,
      ));
    }
  }

  Future<void> getCountriesByRegion(String region) async {
    if (getCountriesByRegionUseCase == null) return;
    try {
      emit(state.copyWith(isLoading: true));
      final tipsModels = await getCountriesByRegionUseCase!(region);
      final tips = tipsModels.map((model) => EcoTip(
        id: model.id,
        title: model.title,
        content: model.content,
        imageUrl: model.imageUrl,
        createdAt: model.createdAt,
      )).toList();
      emit(state.copyWith(
        tipsList: tips,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: 'Ошибка при поиске стран по региону: $e',
        isLoading: false,
      ));
    }
  }

  Future<void> getCountriesBySubregion(String subregion) async {
    if (getCountriesBySubregionUseCase == null) return;
    try {
      emit(state.copyWith(isLoading: true));
      final tipsModels = await getCountriesBySubregionUseCase!(subregion);
      final tips = tipsModels.map((model) => EcoTip(
        id: model.id,
        title: model.title,
        content: model.content,
        imageUrl: model.imageUrl,
        createdAt: model.createdAt,
      )).toList();
      emit(state.copyWith(
        tipsList: tips,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: 'Ошибка при поиске стран по подрегиону: $e',
        isLoading: false,
      ));
    }
  }

  Future<void> getCountriesByCapital(String capital) async {
    if (getCountriesByCapitalUseCase == null) return;
    try {
      emit(state.copyWith(isLoading: true));
      final tipsModels = await getCountriesByCapitalUseCase!(capital);
      final tips = tipsModels.map((model) => EcoTip(
        id: model.id,
        title: model.title,
        content: model.content,
        imageUrl: model.imageUrl,
        createdAt: model.createdAt,
      )).toList();
      emit(state.copyWith(
        tipsList: tips,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: 'Ошибка при поиске стран по столице: $e',
        isLoading: false,
      ));
    }
  }

  void loadRecyclingPoints({String? location, String? filter}) {
    // В реальном приложении здесь будет загрузка с сервера/API
    // Пока используем mock данные
    final allPoints = [
      RecyclingPoint(
        id: '1',
        name: 'Пункт приёма "Эко-Центр"',
        address: 'ул. Экологическая, 10',
        latitude: 55.7558,
        longitude: 37.6173,
        acceptedTypes: ['paper', 'plastic', 'glass', 'metal'],
        phone: '+7 (495) 123-45-67',
      ),
      RecyclingPoint(
        id: '2',
        name: 'Приём электроники "Техно-Рецикл"',
        address: 'пр. Технологический, 25',
        latitude: 55.7500,
        longitude: 37.6200,
        acceptedTypes: ['electronics', 'batteries'],
        phone: '+7 (495) 234-56-78',
      ),
      RecyclingPoint(
        id: '3',
        name: 'Пункт приёма одежды',
        address: 'ул. Текстильная, 5',
        latitude: 55.7600,
        longitude: 37.6100,
        acceptedTypes: ['clothing', 'textiles'],
      ),
    ];

    // Фильтрация по типу, если указан
    final filteredPoints = (filter != null && filter.isNotEmpty)
        ? allPoints.where((p) => p.acceptedTypes.contains(filter)).toList()
        : allPoints;

    emit(state.copyWith(
      recyclingPoints: filteredPoints,
      selectedRecyclingFilter: filter,
    ));
  }
  
  void clearRecyclingFilter() {
    loadRecyclingPoints(filter: null);
  }

  // Wikipedia API методы (5 запросов)
  /// 1. Поиск статей по запросу
  Future<void> searchWikipediaArticles(String query, {int limit = 5}) async {
    if (searchWikipediaArticlesUseCase == null) {
      emit(state.copyWith(error: 'Wikipedia API недоступен'));
      return;
    }
    try {
      emit(state.copyWith(isLoading: true, error: null));
      final tipsModels = await searchWikipediaArticlesUseCase!(query, limit: limit);
      final tips = tipsModels.map((model) => EcoTip(
        id: model.id,
        title: model.title,
        content: model.content,
        imageUrl: model.imageUrl,
        createdAt: model.createdAt,
      )).toList();
      emit(state.copyWith(
        tipsList: tips,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: 'Ошибка при поиске статей Wikipedia: $e',
        isLoading: false,
      ));
    }
  }

  /// 2. Получение содержимого статьи
  Future<void> getWikipediaPageContent(String title) async {
    if (getWikipediaPageContentUseCase == null) {
      emit(state.copyWith(error: 'Wikipedia API недоступен'));
      return;
    }
    try {
      emit(state.copyWith(isLoading: true, error: null));
      final tipModel = await getWikipediaPageContentUseCase!(title);
      final tip = EcoTip(
        id: tipModel.id,
        title: tipModel.title,
        content: tipModel.content,
        imageUrl: tipModel.imageUrl,
        createdAt: tipModel.createdAt,
      );
      emit(state.copyWith(
        tipsList: [tip],
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: 'Ошибка при получении содержимого статьи: $e',
        isLoading: false,
      ));
    }
  }

  /// 3. Получение статей из категории
  Future<void> getWikipediaCategoryArticles(String category, {int limit = 10}) async {
    if (getWikipediaCategoryArticlesUseCase == null) {
      emit(state.copyWith(error: 'Wikipedia API недоступен'));
      return;
    }
    try {
      emit(state.copyWith(isLoading: true, error: null));
      final tipsModels = await getWikipediaCategoryArticlesUseCase!(category, limit: limit);
      final tips = tipsModels.map((model) => EcoTip(
        id: model.id,
        title: model.title,
        content: model.content,
        imageUrl: model.imageUrl,
        createdAt: model.createdAt,
      )).toList();
      emit(state.copyWith(
        tipsList: tips,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: 'Ошибка при получении статей из категории: $e',
        isLoading: false,
      ));
    }
  }

  /// 4. Получение связанных статей
  Future<void> getWikipediaPageLinks(String title, {int limit = 10}) async {
    if (getWikipediaPageLinksUseCase == null) {
      emit(state.copyWith(error: 'Wikipedia API недоступен'));
      return;
    }
    try {
      emit(state.copyWith(isLoading: true, error: null));
      final tipsModels = await getWikipediaPageLinksUseCase!(title, limit: limit);
      final tips = tipsModels.map((model) => EcoTip(
        id: model.id,
        title: model.title,
        content: model.content,
        imageUrl: model.imageUrl,
        createdAt: model.createdAt,
      )).toList();
      emit(state.copyWith(
        tipsList: tips,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: 'Ошибка при получении связанных статей: $e',
        isLoading: false,
      ));
    }
  }

  /// 5. Получение изображений статьи
  Future<void> getWikipediaPageImages(String title, {int limit = 10}) async {
    if (getWikipediaPageImagesUseCase == null) {
      emit(state.copyWith(error: 'Wikipedia API недоступен'));
      return;
    }
    try {
      emit(state.copyWith(isLoading: true, error: null));
      final tipsModels = await getWikipediaPageImagesUseCase!(title, limit: limit);
      final tips = tipsModels.map((model) => EcoTip(
        id: model.id,
        title: model.title,
        content: model.content,
        imageUrl: model.imageUrl,
        createdAt: model.createdAt,
      )).toList();
      emit(state.copyWith(
        tipsList: tips,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: 'Ошибка при получении изображений: $e',
        isLoading: false,
      ));
    }
  }
}

class EcoGuideState {
  final String selectedCategory;
  final List<EcoTip> tipsList;
  final List<RecyclingPoint> recyclingPoints;
  final String? selectedRecyclingFilter;
  final bool isLoading;
  final String? error;

  const EcoGuideState({
    this.selectedCategory = '',
    this.tipsList = const [],
    this.recyclingPoints = const [],
    this.selectedRecyclingFilter,
    this.isLoading = false,
    this.error,
  });

  EcoGuideState copyWith({
    String? selectedCategory,
    List<EcoTip>? tipsList,
    List<RecyclingPoint>? recyclingPoints,
    String? selectedRecyclingFilter,
    bool? isLoading,
    String? error,
  }) {
    return EcoGuideState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      tipsList: tipsList ?? this.tipsList,
      recyclingPoints: recyclingPoints ?? this.recyclingPoints,
      selectedRecyclingFilter: selectedRecyclingFilter ?? this.selectedRecyclingFilter,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
