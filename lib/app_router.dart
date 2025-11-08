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

GoRouter createAppRouter(
    List<Item> allItems,
    List<Item> userItems,
    Function(Item) onAddItem,
    Function(String) onDeleteItem,
    ) {
  return GoRouter(
    initialLocation: AppRoutes.login,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => HomeScreen(
          allItems: allItems,
          userItems: userItems,
          onAddItem: onAddItem,
          onDeleteItem: onDeleteItem,
        ),
      ),
      GoRoute(
        path: AppRoutes.my,
        name: 'my',
        builder: (context, state) => MyListingsScreen(
          myItems: userItems,
          onAddItem: onAddItem,
          onDeleteItem: onDeleteItem,
        ),
      ),
      GoRoute(
        path: AppRoutes.addItem,
        name: 'addItem',
        builder: (context, state) => AddItemScreen(
          ownerName: 'Вы',
          myItems: userItems,
          onAddItem: onAddItem,
        ),
      ),
      GoRoute(
        path: AppRoutes.itemDetail,
        name: 'itemDetail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final item = allItems.firstWhere((i) => i.id == id);
          return ItemDetailScreen(item: item);
        },
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.categories,
        name: 'categories',
        builder: (context, state) => const CategoriesScreen(),
      ),
      GoRoute(
        path: AppRoutes.addresses,
        name: 'addresses',
        builder: (context, state) => const AddressesScreen(),
      ),
    ],
  );
}