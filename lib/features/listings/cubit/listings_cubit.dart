import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/listing_model.dart';
import '../../../domain/usecases/listings/get_all_listings_usecase.dart';
import '../../../domain/usecases/listings/add_listing_usecase.dart';
import '../../../domain/usecases/listings/delete_listing_usecase.dart';
import '../../../domain/usecases/listings/get_listing_by_id_usecase.dart';
import '../../auth/cubit/auth_cubit.dart';


class ListingsCubit extends Cubit<ListingsState> {
  final GetAllListingsUseCase getAllListingsUseCase;
  final AddListingUseCase addListingUseCase;
  final DeleteListingUseCase deleteListingUseCase;
  final GetListingByIdUseCase getListingByIdUseCase;
  final AuthCubit? authCubit;

  ListingsCubit({
    required this.getAllListingsUseCase,
    required this.addListingUseCase,
    required this.deleteListingUseCase,
    required this.getListingByIdUseCase,
    this.authCubit,
  }) : super(ListingsState()) {
    loadListings();
  }

  Future<void> loadListings() async {
    emit(state.copyWith(isLoading: true));
    try {
      final listings = await getAllListingsUseCase();
      emit(state.copyWith(
        allItems: listings,
        filteredItems: listings,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isLoading: false,
      ));
    }
  }

  Future<void> addListing(ListingModel listing) async {
    try {
      final addedListing = await addListingUseCase(listing);
      final newAllItems = [...state.allItems, addedListing];
      final currentUserId = _getCurrentUserId();
      final newMyItems = listing.ownerId == currentUserId
          ? [...state.myItems, addedListing]
          : state.myItems;

      emit(state.copyWith(
        allItems: newAllItems,
        filteredItems: _filterItems(
          newAllItems,
          state.searchQuery,
          state.selectedCategory,
        ),
        myItems: newMyItems,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> removeListing(String id) async {
    try {
      await deleteListingUseCase(id);
      final List<ListingModel> newAllItems = state.allItems.where((item) => item.id != id).toList();
      final List<ListingModel> newMyItems = state.myItems.where((item) => item.id != id).toList();

      emit(state.copyWith(
        allItems: newAllItems,
        filteredItems: _filterItems(
          newAllItems,
          state.searchQuery,
          state.selectedCategory,
        ),
        myItems: newMyItems,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<ListingModel?> getListingById(String id) async {
    try {
      return await getListingByIdUseCase(id);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
      return null;
    }
  }

  void searchListings(String query) {
    emit(state.copyWith(
      searchQuery: query,
      filteredItems: _filterItems(
        state.allItems,
        query,
        state.selectedCategory,
      ),
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
      filteredItems: _filterItems(
        state.allItems,
        '',
        state.selectedCategory,
      ),
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

  void removeFromSearchHistory(String query) {
    final newHistory = state.searchHistory.where((q) => q != query).toList();
    emit(state.copyWith(searchHistory: newHistory));
  }

  List<ListingModel> getMyListings() => state.myItems;

  List<ListingModel> getAllListings() => state.allItems;

  List<ListingModel> _filterItems(
    List<ListingModel> items,
    String query,
    String? category,
  ) {
    List<ListingModel> filtered = items;

    if (category != null && category.isNotEmpty) {
      filtered = List<ListingModel>.from(filtered.where((item) => item.category == category));
    }

    if (query.isNotEmpty) {
      filtered = List<ListingModel>.from(filtered.where((item) =>
          item.title.toLowerCase().contains(query.toLowerCase()) ||
          item.description.toLowerCase().contains(query.toLowerCase())));
    }

    return filtered;
  }

  String _getCurrentUserId() {
    if (authCubit != null && authCubit!.state.isAuthenticated) {
      return authCubit!.state.userEmail ?? '';
    }
    return '';
  }
}

class ListingsState {
  final List<ListingModel> allItems;
  final List<ListingModel> filteredItems;
  final List<ListingModel> myItems;
  final String searchQuery;
  final String? selectedCategory;
  final List<String> searchHistory;
  final bool isLoading;
  final String? error;

  const ListingsState({
    this.allItems = const [],
    this.filteredItems = const [],
    this.myItems = const [],
    this.searchQuery = '',
    this.selectedCategory,
    this.searchHistory = const [],
    this.isLoading = false,
    this.error,
  });

  ListingsState copyWith({
    List<ListingModel>? allItems,
    List<ListingModel>? filteredItems,
    List<ListingModel>? myItems,
    String? searchQuery,
    String? selectedCategory,
    List<String>? searchHistory,
    bool? isLoading,
    String? error,
  }) {
    return ListingsState(
      allItems: allItems ?? this.allItems,
      filteredItems: filteredItems ?? this.filteredItems,
      myItems: myItems ?? this.myItems,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchHistory: searchHistory ?? this.searchHistory,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
