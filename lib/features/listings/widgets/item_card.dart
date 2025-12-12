import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/item.dart';
import '../../../shared/image_helper.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const ItemCard({super.key, required this.item, this.onDelete, this.onTap});

  Widget _buildImage(String? url, String? path, Uint8List? bytes) {
    // Приоритет: imageUrl > imageBytes > imagePath
    if (url != null && (url.startsWith('http://') || url.startsWith('https://'))) {
      return CachedNetworkImage(
        imageUrl: url,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        placeholder: (c, u) => const Center(child: CircularProgressIndicator()),
        errorWidget: (c, u, e) => const Center(child: Icon(Icons.error, color: Colors.red)),
      );
    }
    
    return ImageHelper.buildImageWidget(
      imagePath: path,
      imageBytes: bytes,
      width: 100,
      height: 100,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
          ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              child: Container(
                width: 120,
                height: 120,
                color: theme.colorScheme.surface,
                child: _buildImage(item.imageUrl, item.imagePath, item.imageBytes),
              ),
          ),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: item.forExchange 
                                ? theme.colorScheme.tertiary.withOpacity(0.2)
                                : theme.colorScheme.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item.forExchange ? '🔄 Обмен' : '🎁 Отдам',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: item.forExchange 
                                  ? theme.colorScheme.tertiary
                                  : theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        if (item.category != 'other')
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondary.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _getCategoryLabel(item.category),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.secondary,
                              ),
                            ),
                          ),
                      ],
                    ),
                const SizedBox(height: 4),
                    Text(
                      '👤 ${item.owner}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
            ),
          ),
            if (onDelete != null)
              Padding(
                padding: const EdgeInsets.all(8),
                child: IconButton(
                  icon: const Icon(Icons.delete_outline, size: 22),
                  color: Colors.red[400],
            onPressed: onDelete,
                  tooltip: 'Удалить',
                ),
          ),
          ],
        ),
      ),
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
}