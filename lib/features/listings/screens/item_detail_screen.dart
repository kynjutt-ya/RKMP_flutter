import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/item.dart';

class ItemDetailScreen extends StatelessWidget {
  final Item item;

  const ItemDetailScreen({super.key, required this.item});

  Widget _buildImage(String? path) {
    if (path == null) {
      return Image.asset('assets/placeholder.png',
          width: double.infinity, height: 200, fit: BoxFit.cover);
    }
    if (path.startsWith('assets/')) {
      return Image.asset(path,
          width: double.infinity, height: 200, fit: BoxFit.cover);
    }
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return CachedNetworkImage(
        imageUrl: path,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, progress) =>
        const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) =>
        const Center(child: Icon(Icons.error, color: Colors.red)),
      );
    }
    return Image.file(File(path),
        width: double.infinity, height: 200, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildImage(item.imagePath),
            ),
            const SizedBox(height: 12),
            Text(item.title,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Владелец: ${item.owner}'),
            const SizedBox(height: 8),
            Text(item.description),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Запрос на "${item.title}" отправлен')),
                );
              },
              child: Text(item.forExchange ? 'Предложить обмен' : 'Запросить'),
            ),
          ],
        ),
      ),
    );
  }
}