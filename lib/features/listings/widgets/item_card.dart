import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/item.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const ItemCard({
    super.key,
    required this.item,
    this.onDelete,
    this.onTap,
  });

  Widget _buildImage(String? path) {
    if (path != null && (path.startsWith('http://') || path.startsWith('https://'))) {
      return CachedNetworkImage(
        imageUrl: path,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, progress) =>
        const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => const Center(
          child: Icon(Icons.error, color: Colors.red),
        ),
      );
    }

    if (path != null && File(path).existsSync()) {
      return Image.file(File(path), width: 100, height: 100, fit: BoxFit.cover);
    }

    return Image.asset('assets/placeholder.png', width: 100, height: 100, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
              child: _buildImage(item.imagePath),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(item.description,
                        maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black87)),
                    const SizedBox(height: 6),
                    Text('${item.forExchange ? "Обмен" : "Отдам"} — ${item.owner}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ),
            if (onDelete != null)
              IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
