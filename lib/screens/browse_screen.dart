import 'dart:io';
import 'package:flutter/material.dart';
import '../models/item.dart';
import 'item_detail_screen.dart';

class BrowseScreen extends StatelessWidget {
  final List<Item> items;

  const BrowseScreen({super.key, required this.items});

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
      appBar: AppBar(title: const Text('Просмотр объявлений')),
      body: items.isEmpty
          ? const Center(child: Text('Нет объявлений'))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: items.length,
        itemBuilder: (context, i) {
          final item = items[i];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ItemDetailScreen(item: item),
                  ),
                );
              },
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _buildImage(item.imagePath),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(item.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Text(
                              '${item.forExchange ? "Обмен" : "Отдать"} — ${item.owner}',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey)),
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
    );
  }
}
