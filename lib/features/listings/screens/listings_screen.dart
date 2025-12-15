import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/listings_cubit.dart';
import '../../../shared/item_adapter.dart';
import '../models/item.dart';
import '../widgets/item_table.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../cubit/geocoding_cubit.dart';

class ListingsScreen extends StatelessWidget {
  const ListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return const _ListingsScreenContent();
  }
}

class _ListingsScreenContent extends StatelessWidget {
  const _ListingsScreenContent();

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
              context.read<AuthCubit>().logout();
            },
          ),
        ],
      ),
      body: BlocBuilder<ListingsCubit, ListingsState>(
        builder: (context, state) {
          final displayedItems = state.filteredItems;

          return Column(
            children: [
              _buildBanner(context),
              _buildNavigationButtons(context),
              _buildFilters(context, state),
              if (state.searchQuery.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Chip(
                        label: Text('Поиск: "${state.searchQuery}"'),
                          deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () => context.read<ListingsCubit>().clearSearch(),
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: displayedItems.isEmpty
                    ? const Center(child: Text('Нет объявлений'))
                    : ItemTable(
                  items: ItemAdapter.toItemList(displayedItems),
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

    context.push('/listings/item', extra: item);
  }

  Widget _buildBanner(BuildContext context) {
    const bannerUrl = 'https://avatars.mds.yandex.net/i?id=35a7ecfd8db436726cbcd80a3bc2b439dfb2708f-10555242-images-thumbs&ref=rim&n=33&w=480&h=224';

    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            bannerUrl,
      fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            opacity: const AlwaysStoppedAnimation(0.3),
            errorBuilder: (c, e, s) => const SizedBox.expand(),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ShareNear',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Давайте вещам вторую жизнь',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                    letterSpacing: 0.5,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
        children: [
            _buildNavButton(
              context,
              icon: Icons.add_circle_outline,
              label: 'Добавить',
              onPressed: () => context.push('/listings/add'),
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            _buildNavButton(
              context,
              icon: Icons.list,
              label: 'Мои',
            onPressed: () => context.push('/listings/my'),
              color: theme.colorScheme.secondary,
            ),
            const SizedBox(width: 8),
            _buildNavButton(
              context,
              icon: Icons.person,
              label: 'Профиль',
            onPressed: () => context.go('/profile'),
              color: theme.colorScheme.tertiary,
            ),
            const SizedBox(width: 8),
            _buildNavButton(
              context,
              icon: Icons.eco,
              label: 'Эко-гид',
            onPressed: () => context.go('/eco-guide'),
              color: Colors.green[600]!,
            ),
            const SizedBox(width: 8),
            _buildNavButton(
              context,
              icon: Icons.build,
              label: 'Ремонт',
            onPressed: () => context.go('/repair'),
              color: Colors.orange[600]!,
            ),
            const SizedBox(width: 8),
            _buildNavButton(
              context,
              icon: Icons.analytics,
              label: 'Эко-след',
            onPressed: () => context.go('/impact'),
              color: Colors.teal[600]!,
            ),
            const SizedBox(width: 8),
            _buildNavButton(
              context,
              icon: Icons.support_agent,
              label: 'Поддержка',
            onPressed: () => context.go('/support'),
              color: Colors.blue[600]!,
            ),
            const SizedBox(width: 8),
            _buildNavButton(
              context,
              icon: Icons.recycling,
              label: 'Пункты приема',
              onPressed: () => _showObjectsByTypeDialog(context),
              color: Colors.green[700]!,
            ),
            const SizedBox(width: 8),
            _buildNavButton(
              context,
              icon: Icons.public,
              label: 'Адреса',
              onPressed: () => _showSearchByCountryDialog(context),
              color: Colors.purple[600]!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: color,
                    letterSpacing: 0.3,
                  ),
          ),
        ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilters(BuildContext context, ListingsState state) {
    const categories = [
      'furniture',
      'electronics',
      'clothing',
      'books',
      'toys',
      'kitchen',
      'other',
    ];

    return BlocBuilder<ListingsCubit, ListingsState>(
      builder: (context, currentState) {
        final theme = Theme.of(context);
        return Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ChoiceChip(
                label: const Text('Все'),
                selected: currentState.selectedCategory == null,
                onSelected: (_) {
                  context.read<ListingsCubit>().filterByCategory(null);
                },
                selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                labelStyle: TextStyle(
                  color: currentState.selectedCategory == null
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                  fontWeight: currentState.selectedCategory == null
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              const SizedBox(width: 8),
              ...categories.map((category) {
                final isSelected = currentState.selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(_getCategoryLabel(category)),
                    selected: isSelected,
                    onSelected: (_) {
                      // Если уже выбрана - снимаем фильтр, иначе устанавливаем
                      if (isSelected) {
                        context.read<ListingsCubit>().filterByCategory(null);
                      } else {
                        context.read<ListingsCubit>().filterByCategory(category);
                      }
                    },
                    selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  String _getCategoryLabel(String category) {
    const labels = {
      'furniture': 'Мебель',
      'electronics': 'Электроника',
      'clothing': 'Одежда',
      'books': 'Книги',
      'toys': 'Игрушки',
      'kitchen': 'Кухня',
      'other': 'Другое',
    };
    return labels[category] ?? category;
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

  void _showObjectsByTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: context.read<GeocodingCubit>(),
        child: const _ObjectsByTypeDialog(),
      ),
    );
  }

  void _showSearchByCountryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: context.read<GeocodingCubit>(),
        child: const _SearchByCountryDialog(),
      ),
    );
  }
}

class _ObjectsByTypeDialog extends StatefulWidget {
  const _ObjectsByTypeDialog();

  @override
  State<_ObjectsByTypeDialog> createState() => _ObjectsByTypeDialogState();
}

class _ObjectsByTypeDialogState extends State<_ObjectsByTypeDialog> {
  final _objectTypeController = TextEditingController();
  final _locationController = TextEditingController();
  List<String> _addressSuggestions = [];
  String? _error;
  bool _isSearching = false;

  @override
  void dispose() {
    _objectTypeController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GeocodingCubit, GeocodingState>(
      listener: (context, state) {
        setState(() {
          _addressSuggestions = state.addressSuggestions;
          _error = state.error;
          _isSearching = state.isSearching;
        });
      },
      child: AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.recycling, color: Colors.green),
            SizedBox(width: 8),
            Text('Поиск пунктов приема'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _objectTypeController,
                decoration: const InputDecoration(
                  labelText: 'Тип объекта',
                  hintText: 'Например: магазин, переработка, пункт приема',
                  helperText: 'Можно вводить на русском: магазин, переработка, пункт приема, ремонт',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Город',
                  hintText: 'Например: Москва',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_city),
                ),
              ),
              if (_addressSuggestions.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Найденные объекты:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _addressSuggestions.map((address) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: const Icon(Icons.place, color: Colors.green),
                            title: Text(address),
                            dense: true,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 12),
                Card(
                  color: Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Ошибка: $_error',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
          ElevatedButton.icon(
            onPressed: _isSearching
                ? null
                : () {
                    if (_objectTypeController.text.trim().isNotEmpty &&
                        _locationController.text.trim().isNotEmpty) {
                      context.read<GeocodingCubit>().searchObjectsByType(
                            _objectTypeController.text.trim(),
                            _locationController.text.trim(),
                          );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Введите тип объекта и город'),
                        ),
                      );
                    }
                  },
            icon: _isSearching
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.search),
            label: Text(_isSearching ? 'Поиск...' : 'Найти'),
          ),
        ],
      ),
    );
  }
}

class _SearchByCountryDialog extends StatefulWidget {
  const _SearchByCountryDialog();

  @override
  State<_SearchByCountryDialog> createState() => _SearchByCountryDialogState();
}

class _SearchByCountryDialogState extends State<_SearchByCountryDialog> {
  final _queryController = TextEditingController();
  final _countryController = TextEditingController();
  List<String> _addressSuggestions = [];
  String? _error;
  bool _isSearching = false;

  @override
  void dispose() {
    _queryController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GeocodingCubit, GeocodingState>(
      listener: (context, state) {
        setState(() {
          _addressSuggestions = state.addressSuggestions;
          _error = state.error;
          _isSearching = state.isSearching;
        });
      },
      child: AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.public, color: Colors.purple),
            SizedBox(width: 8),
            Text('Поиск адресов в стране'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _queryController,
                decoration: const InputDecoration(
                  labelText: 'Запрос',
                  hintText: 'Например: улица, площадь',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _countryController,
                decoration: const InputDecoration(
                  labelText: 'Страна',
                  hintText: 'Например: Россия',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.flag),
                ),
              ),
              if (_addressSuggestions.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Найденные адреса:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _addressSuggestions.map((address) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: const Icon(Icons.location_on, color: Colors.purple),
                            title: Text(address),
                            dense: true,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 12),
                Card(
                  color: Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Ошибка: $_error',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
          ElevatedButton.icon(
            onPressed: _isSearching
                ? null
                : () {
                    if (_queryController.text.trim().isNotEmpty &&
                        _countryController.text.trim().isNotEmpty) {
                      context.read<GeocodingCubit>().searchAddressesByCountry(
                            _queryController.text.trim(),
                            _countryController.text.trim(),
                          );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Введите запрос и страну'),
                        ),
                      );
                    }
                  },
            icon: _isSearching
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.search),
            label: Text(_isSearching ? 'Поиск...' : 'Найти'),
          ),
        ],
      ),
    );
  }
}