import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/item.dart';

class ListingsCubit extends Cubit<ListingsState> {
  ListingsCubit() : super(ListingsState()) {
    _initializeDemoData();
  }

  void _initializeDemoData() {
    final demoItems = [
      Item(
        id: '1',
        title: 'Настольная лампа',
        description: 'Современная настольная лампа в хорошем состоянии',
        forExchange: false,
        ownerId: 'alexey@example.com',
        owner: 'Алексей',
        imageUrl: 'https://cdn1.ozone.ru/s3/multimedia-c/6397661772.jpg',
        category: 'electronics',
        condition: 'good',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Item(
        id: '2',
        title: 'Кресло',
        description: 'Мягкое офисное кресло, возможен обмен',
        forExchange: true,
        ownerId: 'irina@example.com',
        owner: 'Ирина',
        imageUrl: 'https://avatars.mds.yandex.net/get-mpic/12366926/2a00000193f6a60316c7671dbd7ce04821a8/orig',
        category: 'furniture',
        condition: 'used',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Item(
        id: '3',
        title: 'Полка для книг',
        description: 'Деревянная полка, отличное состояние',
        forExchange: false,
        ownerId: 'mikhail@example.com',
        owner: 'Михаил',
        imageUrl: 'https://avatars.mds.yandex.net/i?id=86d5887e8ef7cbf34155b28dc5aac7b5_l-4483413-images-thumbs&n=13',
        category: 'furniture',
        condition: 'good',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Item(
        id: '4',
        title: 'Детские книги',
        description: 'Коллекция детских книг, хорошее состояние',
        forExchange: true,
        ownerId: 'maria@example.com',
        owner: 'Мария',
        imageUrl: 'https://picsum.photos/seed/books/400/300',
        category: 'books',
        condition: 'good',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      Item(
        id: '5',
        title: 'Куртка зимняя',
        description: 'Тёплая зимняя куртка, размер M',
        forExchange: false,
        ownerId: 'dmitry@example.com',
        owner: 'Дмитрий',
        imageUrl: 'https://picsum.photos/seed/clothing/400/300',
        category: 'clothing',
        condition: 'good',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
      Item(
        id: '6',
        title: 'Набор игрушек',
        description: 'Развивающие игрушки для детей',
        forExchange: true,
        ownerId: 'olga@example.com',
        owner: 'Ольга',
        imageUrl: 'https://picsum.photos/seed/toys/400/300',
        category: 'toys',
        condition: 'used',
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
      ),
      Item(
        id: '7',
        title: 'Кофемашина',
        description: 'Кофемашина в рабочем состоянии',
        forExchange: false,
        ownerId: 'sergey@example.com',
        owner: 'Сергей',
        imageUrl: 'https://picsum.photos/seed/coffee/400/300',
        category: 'kitchen',
        condition: 'used',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
    ];

    emit(state.copyWith(
      allItems: demoItems,
      filteredItems: demoItems,
      myItems: [],
      selectedCategory: null,
    ));
  }

  void removeFromSearchHistory(String query) {
    final newHistory = state.searchHistory.where((q) => q != query).toList();
    emit(state.copyWith(searchHistory: newHistory));
  }

  void addListing(Item item) {
    final newAllItems = [...state.allItems, item];
    final newMyItems = [...state.myItems, item];

    emit(state.copyWith(
      allItems: newAllItems,
      filteredItems: _filterItems(newAllItems, state.searchQuery, state.selectedCategory),
      myItems: newMyItems,
    ));
  }

  void removeListing(String id) {
    final newAllItems = state.allItems.where((item) => item.id != id).toList();
    final newMyItems = state.myItems.where((item) => item.id != id).toList();

    emit(state.copyWith(
      allItems: newAllItems,
      filteredItems: _filterItems(newAllItems, state.searchQuery, state.selectedCategory),
      myItems: newMyItems,
    ));
  }

  List<Item> getMyListings() => state.myItems;

  List<Item> getAllListings() => state.allItems;

  void searchListings(String query) {
    emit(state.copyWith(
      searchQuery: query,
      filteredItems: _filterItems(state.allItems, query, state.selectedCategory),
    ));
  }

  void filterByCategory(String? category) {
    final newCategory = category == null || category.isEmpty ? null : category;
    emit(state.copyWith(
      selectedCategory: newCategory,
      filteredItems: _filterItems(
        state.allItems,
        state.searchQuery,
        newCategory,
      ),
    ));
  }

  void clearSearch() {
    emit(state.copyWith(
      searchQuery: '',
      filteredItems: _filterItems(state.allItems, '', state.selectedCategory),
    ));
  }

  void clearFilters() {
    emit(state.copyWith(
      searchQuery: '',
      selectedCategory: null,
      filteredItems: state.allItems,
    ));
  }

  void addToSearchHistory(String query) {
    if (query.isNotEmpty && !state.searchHistory.contains(query)) {
      final newHistory = [...state.searchHistory, query];
      emit(state.copyWith(searchHistory: newHistory));
    }
  }

  List<Item> _filterItems(List<Item> items, String query, String? category) {
    var filtered = items;

    // Фильтр по категории
    if (category != null && category.isNotEmpty) {
      filtered = filtered.where((item) => item.category == category).toList();
    }

    // Фильтр по поисковому запросу
    if (query.isNotEmpty) {
      filtered = filtered.where((item) =>
          item.title.toLowerCase().contains(query.toLowerCase()) ||
          item.description.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }

    return filtered;
  }
}

class ListingsState {
  final List<Item> allItems;
  final List<Item> filteredItems;
  final List<Item> myItems;
  final String searchQuery;
  final String? selectedCategory;
  final List<String> searchHistory;

  const ListingsState({
    this.allItems = const [],
    this.filteredItems = const [],
    this.myItems = const [],
    this.searchQuery = '',
    this.selectedCategory,
    this.searchHistory = const [],
  });

  ListingsState copyWith({
    List<Item>? allItems,
    List<Item>? filteredItems,
    List<Item>? myItems,
    String? searchQuery,
    String? selectedCategory,
    List<String>? searchHistory,
  }) {
    return ListingsState(
      allItems: allItems ?? this.allItems,
      filteredItems: filteredItems ?? this.filteredItems,
      myItems: myItems ?? this.myItems,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchHistory: searchHistory ?? this.searchHistory,
    );
  }
}