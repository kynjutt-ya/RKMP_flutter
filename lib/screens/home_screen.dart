import 'dart:io';
import 'package:flutter/material.dart';
import '../models/item.dart';
import 'browse_screen.dart';
import 'add_item_screen.dart';
import 'my_listings_screen.dart';
import 'item_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Item> _items = [
    Item(
      id: '1',
      title: 'Книги — Художественная литература',
      description: 'Набор книг в хорошем состоянии, можно забирать — отдам.',
      forExchange: false,
      owner: 'Анна',
      imagePath: 'assets/books.png', // локальный asset
    ),
    Item(
      id: '2',
      title: 'Смартфон (на запчасти)',
      description: 'Экран треснул, батарея держит. Можно обменять на наушники.',
      forExchange: true,
      owner: 'Иван',
      imagePath: 'assets/phone.png', // локальный asset
    ),
  ];

  void _handleNewItem(Item newItem) {
    setState(() {
      _items.add(newItem);
    });
  }

  void _handleDelete(String id) {
    setState(() {
      _items.removeWhere((it) => it.id == id);
    });
  }

  Widget _buildImage(String? path) {
    if (path == null) {
      return Image.asset('assets/placeholder.png',
          width: 100, height: 100, fit: BoxFit.cover);
    }
    if (path.startsWith('assets/')) {
      return Image.asset(path, width: 100, height: 100, fit: BoxFit.cover);
    }
    return Image.file(File(path), width: 100, height: 100, fit: BoxFit.cover);
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
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Text('Всего объявлений: ${_items.length}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.of(context).push<Item>(
                        MaterialPageRoute(
                          builder: (_) => AddItemScreen(ownerName: 'Вы'),
                        ),
                      );
                      if (result != null) {
                        _handleNewItem(result);
                      }
                    },
                    child: const Text('Добавить'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BrowseScreen(items: _items),
                      ),
                    );
                  },
                  icon: const Icon(Icons.list),
                  label: const Text('Просмотреть'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MyListingsScreen(
                            items: _items, onDelete: _handleDelete),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person),
                  label: const Text('Мои объявления'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _items.isEmpty
                  ? const Center(child: Text('Пока нет объявлений'))
                  : ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, i) {
                  final it = _items[i];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ItemDetailScreen(item: it),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: _buildImage(it.imagePath),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(it.title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(it.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  Text(
                                      '${it.forExchange ? "Обмен" : "Отдать"} — ${it.owner}',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
