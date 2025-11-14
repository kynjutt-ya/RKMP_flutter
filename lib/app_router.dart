import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/listings/screens/home_screen.dart';
import 'features/listings/screens/my_listings_screen.dart';
import 'features/listings/screens/add_item_screen.dart';
import 'features/listings/screens/item_detail_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/categories/screens/categories_screen.dart';
import 'features/addresses/screens/addresses_screen.dart';
import 'shared/app_state.dart';
import 'features/listings/models/item.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/';
  static const String my = '/my';
  static const String addItem = '/my/add';
  static const String itemDetail = '/item/:id';
  static const String profile = '/profile';
  static const String categories = '/categories';
  static const String addresses = '/addresses';
}

GoRouter createAppRouter(Function(Item) onAddItem, Function(String) onDeleteItem) {
  return GoRouter(
    initialLocation: AppRoutes.login,
    routes: [
      GoRoute(path: AppRoutes.login, name: 'login', builder: (c, s) => const LoginScreen()),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (c, s) => HomeScreen(onAddItem: onAddItem, onDeleteItem: onDeleteItem),
      ),
      GoRoute(
        path: AppRoutes.my,
        name: 'my',
        builder: (c, s) => MyListingsScreen(onAddItem: onAddItem, onDeleteItem: onDeleteItem),
      ),
      GoRoute(
        path: AppRoutes.addItem,
        name: 'addItem',
        builder: (c, s) => AddItemScreen(ownerName: 'Вы', onAddItem: onAddItem),
      ),
      GoRoute(
        path: AppRoutes.itemDetail,
        name: 'itemDetail',
        builder: (c, s) {
          final id = s.pathParameters['id']!;
          final allItems = AppStateProvider.of(c)?.allItems ?? [];
          final item = allItems.firstWhere((i) => i.id == id, orElse: () => Item.empty());
          return ItemDetailScreen(item: item);
        },
      ),
      GoRoute(path: AppRoutes.profile, name: 'profile', builder: (c, s) => const ProfileScreen()),
      GoRoute(path: AppRoutes.categories, name: 'categories', builder: (c, s) => const CategoriesScreen()),
      GoRoute(path: AppRoutes.addresses, name: 'addresses', builder: (c, s) => const AddressesScreen()),
    ],
  );
}