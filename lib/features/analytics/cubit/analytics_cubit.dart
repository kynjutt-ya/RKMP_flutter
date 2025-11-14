import 'package:flutter_bloc/flutter_bloc.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  AnalyticsCubit() : super(AnalyticsState());

  void recordScreenView(String screenName) {
    if (state.screenViews[screenName] != null) {
      return;
    }

    final newViews = {...state.screenViews};
    newViews.update(
      screenName,
          (value) => value + 1,
      ifAbsent: () => 1,
    );

    emit(state.copyWith(
      screenViews: newViews,
      totalSessions: state.totalSessions + 1,
    ));
  }

  void recordItemView(String itemId) {
    final newItemViews = {...state.itemViews};
    newItemViews.update(
      itemId,
          (value) => value + 1,
      ifAbsent: () => 1,
    );
    emit(state.copyWith(itemViews: newItemViews));
  }

  void recordSearch(String query) {
    final newSearches = {...state.searchQueries};
    newSearches.update(
      query,
          (value) => value + 1,
      ifAbsent: () => 1,
    );
    emit(state.copyWith(searchQueries: newSearches));
  }

  void resetStatistics() {
    emit(AnalyticsState());
  }
}

class AnalyticsState {
  final Map<String, int> screenViews;
  final Map<String, int> itemViews;
  final Map<String, int> searchQueries;
  final int totalSessions;

  const AnalyticsState({
    this.screenViews = const {},
    this.itemViews = const {},
    this.searchQueries = const {},
    this.totalSessions = 0,
  });

  AnalyticsState copyWith({
    Map<String, int>? screenViews,
    Map<String, int>? itemViews,
    Map<String, int>? searchQueries,
    int? totalSessions,
  }) {
    return AnalyticsState(
      screenViews: screenViews ?? this.screenViews,
      itemViews: itemViews ?? this.itemViews,
      searchQueries: searchQueries ?? this.searchQueries,
      totalSessions: totalSessions ?? this.totalSessions,
    );
  }
}