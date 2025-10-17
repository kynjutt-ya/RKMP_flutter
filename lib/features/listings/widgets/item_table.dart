import 'package:flutter/material.dart';
import '../models/item.dart';
import 'item_card.dart';

class ItemTable extends StatelessWidget {
  final List<Item> items;
  final Function(String)? onDelete;
  final Function(Item)? onTap;

  const ItemTable({
    super.key,
    required this.items,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Text(
          'Список пуст',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        return ItemCard(
          key: ValueKey(item.id),
          item: item,
          onTap: onTap != null ? () => onTap!(item) : null,
          onDelete: onDelete != null ? () => onDelete!(item.id) : null,
        );
      },
    );
  }
}
