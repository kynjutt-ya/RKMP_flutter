import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'shared/app_state.dart';
import 'features/listings/models/item.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/listings/screens/home_screen.dart';
import 'features/listings/screens/my_listings_screen.dart';
import 'features/listings/screens/add_item_screen.dart';
import 'features/listings/screens/item_detail_screen.dart';
import 'features/categories/screens/categories_screen.dart';
import 'features/addresses/screens/addresses_screen.dart';
import 'features/profile/screens/profile_screen.dart';

class AppRoutes {
  static const login = '/login';
  static const home = '/';
  static const my = '/my';
  static const addItem = '/my/add';
  static const itemDetail = '/item/:id';
  static const profile = '/profile';
  static const categories = '/categories';
  static const addresses = '/addresses';
}

GoRouter createAppRouter(Function(Item) onAdd, Function(String) onDelete) {
  return GoRouter(initialLocation: AppRoutes.login, routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (c, s) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (c, s) => HomeScreen(onAddItem: onAdd, onDeleteItem: onDelete),
    ),
    GoRoute(
      path: AppRoutes.my,
      builder: (c, s) => const MyListingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.addItem,
      builder: (c, s) => AddItemScreen(ownerName: 'Вы', onAddItem: onAdd),
    ),
    GoRoute(
      path: AppRoutes.itemDetail,
      builder: (c, s) {
        final id = s.pathParameters['id']!;
        final allItems = AppStateProvider.of(c)!.allItems;
        final item = allItems.firstWhere((i) => i.id == id, orElse: () => Item.empty());
        return ItemDetailScreen(item: item);
      },
    ),
    GoRoute(path: AppRoutes.profile, builder: (c, s) => const ProfileScreen()),
    GoRoute(path: AppRoutes.categories, builder: (c, s) => const CategoriesScreen()),
    GoRoute(path: AppRoutes.addresses, builder: (c, s) => const AddressesScreen()),
  ]);
}