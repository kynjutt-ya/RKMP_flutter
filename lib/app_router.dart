import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/listings/screens/home_screen.dart';
import 'features/listings/screens/my_listings_screen.dart';
import 'features/categories/screens/categories_screen.dart';
import 'features/addresses/screens/addresses_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/listings/screens/item_detail_screen.dart';
import 'features/listings/screens/add_item_screen.dart';
import 'features/listings/models/item.dart';

class AppRoutes {
  static const String home = '/';
  static const String myListings = '/my';
  static const String categories = '/categories';
  static const String addresses = '/addresses';
  static const String profile = '/profile';
  static const String itemDetail = '/item/:id';
  static const String addItem = '/my/add';
}

GoRouter createAppRouter(List<Item> allItems, List<Item> userItems, Function(Item) onAddItem, Function(String) onDeleteItem) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: HomeScreen(
            allItems: allItems,
            userItems: userItems,
            onAddItem: onAddItem,
            onDeleteItem: onDeleteItem,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
        ),
      ),
      GoRoute(
        path: AppRoutes.myListings,
        name: 'myListings',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: MyListingsScreen(
            myItems: userItems,
            onAdd: onAddItem,
            onDelete: onDeleteItem,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
        ),
      ),
      GoRoute(
        path: AppRoutes.categories,
        name: 'categories',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const CategoriesScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
        ),
      ),
      GoRoute(
        path: AppRoutes.addresses,
        name: 'addresses',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const AddressesScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
        ),
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const ProfileScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
        ),
      ),
      GoRoute(
        path: AppRoutes.itemDetail,
        name: 'itemDetail',
        pageBuilder: (context, state) {
          final itemId = state.pathParameters['id'];
          final item = allItems.firstWhere((item) => item.id == itemId, orElse: () => Item.empty());
          return CustomTransitionPage(
            child: ItemDetailScreen(item: item),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.addItem,
        name: 'addItem',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: AddItemScreen(
            ownerName: 'Вы',
            onAdd: onAddItem,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
        ),
      ),
    ],
    errorBuilder: (context, state) => const Scaffold(
      body: Center(child: Text('404 - Страница не найдена')),
    ),
  );
}