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
        owner: 'Алексей',
        imagePath: 'https://cdn1.ozone.ru/s3/multimedia-c/6397661772.jpg',
      ),
      Item(
        id: '2',
        title: 'Кресло',
        description: 'Мягкое офисное кресло, возможен обмен',
        forExchange: true,
        owner: 'Ирина',
        imagePath: 'https://avatars.mds.yandex.net/get-mpic/12366926/2a00000193f6a60316c7671dbd7ce04821a8/orig',
      ),
      Item(
        id: '3',
        title: 'Полка для книг',
        description: 'Деревянная полка, отличное состояние',
        forExchange: false,
        owner: 'Михаил',
        imagePath: 'https://avatars.mds.yandex.net/i?id=86d5887e8ef7cbf34155b28dc5aac7b5_l-4483413-images-thumbs&n=13',
      ),
    ];

    emit(state.copyWith(
      allItems: demoItems,
      filteredItems: demoItems,
      myItems: [],
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
      filteredItems: _filterItems(newAllItems, state.searchQuery),
      myItems: newMyItems,
    ));
  }

  void removeListing(String id) {
    final newAllItems = state.allItems.where((item) => item.id != id).toList();
    final newMyItems = state.myItems.where((item) => item.id != id).toList();

    emit(state.copyWith(
      allItems: newAllItems,
      filteredItems: _filterItems(newAllItems, state.searchQuery),
      myItems: newMyItems,
    ));
  }

  List<Item> getMyListings() => state.myItems;

  List<Item> getAllListings() => state.allItems;

  void searchListings(String query) {
    emit(state.copyWith(
      searchQuery: query,
      filteredItems: _filterItems(state.allItems, query),
    ));
  }

  void clearSearch() {
    emit(state.copyWith(
      searchQuery: '',
      filteredItems: state.allItems,
    ));
  }

  void addToSearchHistory(String query) {
    if (query.isNotEmpty && !state.searchHistory.contains(query)) {
      final newHistory = [...state.searchHistory, query];
      emit(state.copyWith(searchHistory: newHistory));
    }
  }

  List<Item> _filterItems(List<Item> items, String query) {
    if (query.isEmpty) return items;
    return items.where((item) =>
    item.title.toLowerCase().contains(query.toLowerCase()) ||
        item.description.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}

class ListingsState {
  final List<Item> allItems;
  final List<Item> filteredItems;
  final List<Item> myItems;
  final String searchQuery;
  final List<String> searchHistory;

  const ListingsState({
    this.allItems = const [],
    this.filteredItems = const [],
    this.myItems = const [],
    this.searchQuery = '',
    this.searchHistory = const [],
  });

  ListingsState copyWith({
    List<Item>? allItems,
    List<Item>? filteredItems,
    List<Item>? myItems,
    String? searchQuery,
    List<String>? searchHistory,
  }) {
    return ListingsState(
      allItems: allItems ?? this.allItems,
      filteredItems: filteredItems ?? this.filteredItems,
      myItems: myItems ?? this.myItems,
      searchQuery: searchQuery ?? this.searchQuery,
      searchHistory: searchHistory ?? this.searchHistory,
    );
  }
}