import 'package:flutter/material.dart';
import '../models/item.dart';
import 'item_card.dart';

class ItemTable extends StatelessWidget {
  final List<Item> items;
  final Function(String)? onDelete;
  final Function(Item)? onTap;

  const ItemTable({super.key, required this.items, this.onDelete, this.onTap});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inbox_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'Нет объявлений',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Добавьте первое объявление',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final it = items[i];
        return ItemCard(
          key: ValueKey(it.id),
          item: it,
          onTap: onTap != null ? () => onTap!(it) : null,
          onDelete: onDelete != null ? () => onDelete!(it.id) : null,
        );
      },
    );
  }
}