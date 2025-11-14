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
      return const Center(child: Text('Список пуст', style: TextStyle(fontSize: 16, color: Colors.grey)));
    }

    return ListView.builder(
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