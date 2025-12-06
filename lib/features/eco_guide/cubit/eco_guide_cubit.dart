// lib/features/eco_guide/cubit/eco_guide_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final List<String> acceptedTypes; // paper, electronics, plastic, etc.
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
  EcoGuideCubit() : super(const EcoGuideState()) {
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
}

class EcoGuideState {
  final String selectedCategory;
  final List<EcoTip> tipsList;
  final List<RecyclingPoint> recyclingPoints;
  final String? selectedRecyclingFilter;

  const EcoGuideState({
    this.selectedCategory = '',
    this.tipsList = const [],
    this.recyclingPoints = const [],
    this.selectedRecyclingFilter,
  });

  EcoGuideState copyWith({
    String? selectedCategory,
    List<EcoTip>? tipsList,
    List<RecyclingPoint>? recyclingPoints,
    String? selectedRecyclingFilter,
  }) {
    return EcoGuideState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      tipsList: tipsList ?? this.tipsList,
      recyclingPoints: recyclingPoints ?? this.recyclingPoints,
      selectedRecyclingFilter: selectedRecyclingFilter ?? this.selectedRecyclingFilter,
    );
  }
}
