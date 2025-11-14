import 'package:flutter/material.dart';
import '../features/listings/models/item.dart';

class AppState {
  final List<Item> allItems;
  final List<Item> userItems;

  const AppState({
    required this.allItems,
    required this.userItems,
  });

  AppState copyWith({
    List<Item>? allItems,
    List<Item>? userItems,
  }) {
    return AppState(
      allItems: allItems ?? this.allItems,
      userItems: userItems ?? this.userItems,
    );
  }
}

class AppStateProvider extends InheritedWidget {
  final AppState state;

  const AppStateProvider({
    super.key,
    required super.child,
    required this.state,
  });

  static AppState? of(BuildContext context) {
    final provider =
    context.dependOnInheritedWidgetOfExactType<AppStateProvider>();
    return provider?.state;
  }

  @override
  bool updateShouldNotify(AppStateProvider oldWidget) {
    return !_listEquals(oldWidget.state.allItems, state.allItems) ||
        !_listEquals(oldWidget.state.userItems, state.userItems);
  }

  bool _listEquals(List<Item> a, List<Item> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id) return false;
    }
    return true;
  }
}
