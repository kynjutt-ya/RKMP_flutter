import 'package:flutter/material.dart';
import '../models/item.dart';
import '../screens/add_item_screen.dart';
import '../screens/my_listings_screen.dart';
import '../screens/item_detail_screen.dart';
import '../../../../features/categories/screens/categories_screen.dart';
import '../../../../features/addresses/screens/addresses_screen.dart';
import '../widgets/item_table.dart';

class HomeContainer extends StatefulWidget {
  const HomeContainer({super.key});

  @override
  State<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  final List<Item> _allItems = [];
  final List<Item> _userItems = [];
  Item? _recentlyDeleted;

  @override
  void initState() {
    super.initState();
    _initializeDemoData();
  }

  void _initializeDemoData() {
    _allItems.addAll([
      Item(
        id: '1',
        title: 'Книги — Художественная литература',
        description: 'Набор книг в хорошем состоянии, можно забирать — отдам.',
        forExchange: false,
        owner: 'Анна',
        imagePath: 'assets/books.png',
      ),
      Item(
        id: '2',
        title: 'Смартфон (на запчасти)',
        description: 'Экран треснул, батарея держит. Можно обменять на наушники.',
        forExchange: true,
        owner: 'Иван',
        imagePath: 'assets/phone.png',
      ),
    ]);
  }
  void _addMyItem(Item item) {
    setState(() {
      _userItems.add(item);
      _allItems.add(item);
    });
  }

  void _removeMyItem(String id) {
    final idx = _userItems.indexWhere((it) => it.id == id);
    if (idx == -1) return;

    final deleted = _userItems[idx];

    setState(() {
      _userItems.removeAt(idx);
      _allItems.removeWhere((it) => it.id == id);
      _recentlyDeleted = deleted;
    });

    _showUndoSnackbar();
  }

  void _undoRemove() {
    if (_recentlyDeleted == null) return;
    setState(() {
      _userItems.add(_recentlyDeleted!);
      _allItems.add(_recentlyDeleted!);
      _recentlyDeleted = null;
    });
  }

  void _showUndoSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Объявление удалено'),
        action: SnackBarAction(label: 'Отменить', onPressed: _undoRemove),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _openMyListings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MyListingsScreen(
          myItems: _userItems,
          onAdd: _addMyItem,
          onDelete: _removeMyItem,
        ),
      ),
    );
  }

  void _openCategories() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CategoriesScreen()),
    );
  }

  void _openAddresses() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddressesScreen()),
    );
  }

  void _openDetails(Item item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ItemDetailScreen(item: item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('От соседей — мини-маркетплейс')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.person),
                    label: const Text('Мои объявления'),
                    onPressed: _openMyListings,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.category),
                    label: const Text('Категории'),
                    onPressed: _openCategories,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.location_on),
                    label: const Text('Адреса'),
                    onPressed: _openAddresses,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: ItemTable(
                items: _allItems,
                onTap: _openDetails,
                onDelete: null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
