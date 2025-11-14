import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/listings_cubit.dart';
import '../models/item.dart';
import '../widgets/item_table.dart';
import 'my_listings_screen.dart';
import 'add_item_screen.dart';
import 'item_detail_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../settings/screens/settings_screen.dart';
import '../../analytics/screens/analytics_screen.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../analytics/cubit/analytics_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnalyticsCubit>().recordScreenView('home_screen');
    });

    return const _HomeScreenContent();
  }
}

class _HomeScreenContent extends StatelessWidget {
  const _HomeScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Объявления соседей'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              print('Нажата кнопка выхода');
              context.read<AuthCubit>().logout();
            },
          ),
        ],
      ),
      body: BlocBuilder<ListingsCubit, ListingsState>(
        builder: (context, state) {
          final displayedItems = state.searchQuery.isEmpty
              ? state.allItems
              : state.filteredItems;

          return Column(
            children: [
              _buildBanner(),
              _buildNavigationButtons(context),
              if (state.searchQuery.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Chip(
                        label: Text('Поиск: "${state.searchQuery}"'),
                        deleteIcon: const Icon(Icons.close),
                        onDeleted: () => context.read<ListingsCubit>().clearSearch(),
                      ),
                    ],
                  ),
                ),
              ],
              Expanded(
                child: displayedItems.isEmpty
                    ? const Center(child: Text('Нет объявлений'))
                    : ItemTable(
                  items: displayedItems,
                  onTap: (item) => _openItemDetail(context, item),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _openItemDetail(BuildContext context, Item item) {
    context.read<AnalyticsCubit>().recordItemView(item.id);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailScreen(item: item),
      ),
    );
  }

  Widget _buildBanner() {
    const bannerUrl = 'https://avatars.mds.yandex.net/i?id=35a7ecfd8db436726cbcd80a3bc2b439dfb2708f-10555242-images-thumbs&ref=rim&n=33&w=480&h=224';

    return Image.network(
      bannerUrl,
      width: double.infinity,
      height: 180,
      fit: BoxFit.cover,
      errorBuilder: (c, e, s) => Container(
        height: 180,
        color: Colors.grey[300],
        child: const Icon(Icons.error),
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyListingsScreen()),
            ),
            child: const Text('Мои объявления'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            ),
            child: const Text('Профиль'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
            child: const Text('Настройки'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AnalyticsScreen()),
            ),
            child: const Text('Статистика'),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    final searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder<ListingsCubit, ListingsState>(
          builder: (context, state) {
            return AlertDialog(
              title: const Text('Поиск объявлений'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Введите запрос...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onSubmitted: (query) {
                      context.read<ListingsCubit>().searchListings(query);
                      context.read<ListingsCubit>().addToSearchHistory(query);
                      context.read<AnalyticsCubit>().recordSearch(query);
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 16),
                  if (state.searchHistory.isNotEmpty) ...[
                    const Text('История поиска:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ...state.searchHistory.map((query) => ListTile(
                      title: Text(query),
                      trailing: IconButton(
                        icon: const Icon(Icons.close, size: 16),
                        onPressed: () {
                          context.read<ListingsCubit>().removeFromSearchHistory(query);
                        },
                      ),
                      onTap: () {
                        context.read<ListingsCubit>().searchListings(query);
                        context.read<AnalyticsCubit>().recordSearch(query);
                        Navigator.pop(context);
                      },
                    )).toList(),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Отмена'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final query = searchController.text.trim();
                    context.read<ListingsCubit>().searchListings(query);
                    context.read<ListingsCubit>().addToSearchHistory(query);
                    context.read<AnalyticsCubit>().recordSearch(query);
                    Navigator.pop(context);
                  },
                  child: const Text('Искать'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}