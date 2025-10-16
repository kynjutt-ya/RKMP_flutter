import 'dart:io';
import 'package:flutter/material.dart';
import '../../listings/models/item.dart';
import '../../listings/screens/my_listings_screen.dart';
import '../../listings/screens/item_detail_screen.dart';
import '../../categories/screens/categories_screen.dart';
import '../../addresses/screens/addresses_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Item> _allItems = [];
  final List<Item> _userItems = [];

  @override
  void initState() {
    super.initState();
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
        description:
        'Экран треснул, батарея держит. Можно обменять на наушники.',
        forExchange: true,
        owner: 'Иван',
        imagePath: 'assets/phone.png',
      ),
    ]);
  }

  void _handleAdd(Item newItem) {
    setState(() {
      _allItems.add(newItem);
      _userItems.add(newItem);
    });
  }

  void _handleDelete(String id) {
    setState(() {
      _allItems.removeWhere((it) => it.id == id);
      _userItems.removeWhere((it) => it.id == id);
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
              child: Text(
                'Всего объявлений: ${_allItems.length}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),

            // Навигационные кнопки
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MyListingsScreen(
                          myItems: _userItems,
                          onAdd: _handleAdd,
                          onDelete: _handleDelete,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person),
                  label: const Text('Мои объявления'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CategoriesScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.category),
                  label: const Text('Категории'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddressesScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.location_on),
                  label: const Text('Адреса'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Список всех объявлений
            Expanded(
              child: _allItems.isEmpty
                  ? const Center(
                child: Text(
                  'Пока нет объявлений',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: _allItems.length,
                itemBuilder: (context, i) {
                  final it = _allItems[i];
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
                                  Text(
                                    it.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${it.forExchange ? "Обмен" : "Отдать"} — ${it.owner}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
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
