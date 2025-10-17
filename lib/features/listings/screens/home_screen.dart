import 'dart:io';
import 'package:flutter/material.dart';
import '../models/item.dart';
import 'item_detail_screen.dart';
import 'my_listings_screen.dart';
import 'add_item_screen.dart';
import '../widgets/item_table.dart';
import '../../addresses/screens/addresses_screen.dart';
import '../../categories/screens/categories_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Item> _allItems = [
    Item(
      id: '1',
      title: 'Книги — художественная литература',
      description: 'Набор книг в хорошем состоянии, можно забрать бесплатно.',
      forExchange: false,
      owner: 'Анна',
      imagePath: 'assets/books.png',
    ),
    Item(
      id: '2',
      title: 'Смартфон (на запчасти)',
      description: 'Треснут экран, но рабочий аккумулятор. Можно обменять.',
      forExchange: true,
      owner: 'Иван',
      imagePath: 'assets/phone.png',
    ),
  ];

  final List<Item> _myItems = [];

  void _addMyItem(Item newItem) {
    setState(() {
      _myItems.add(newItem);
      _allItems.add(newItem);
    });
  }

  void _removeMyItem(String id) {
    setState(() {
      _myItems.removeWhere((it) => it.id == id);
      _allItems.removeWhere((it) => it.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('От соседей — мини-маркетплейс')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.category),
                  label: const Text('Категории'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CategoriesScreen(),
                      ),
                    );
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.person),
                  label: const Text('Мои объявления'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MyListingsScreen(
                          myItems: _myItems,
                          onAdd: _addMyItem,
                          onDelete: _removeMyItem,
                        ),
                      ),
                    );
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.location_on),
                  label: const Text('Адреса'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddressesScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ItemTable(
                items: _allItems,
                onTap: (item) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ItemDetailScreen(item: item),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
