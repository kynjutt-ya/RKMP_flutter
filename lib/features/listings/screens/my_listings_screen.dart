import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/item.dart';
import '../widgets/item_table.dart';

class MyListingsScreen extends StatelessWidget {
  final List<Item> myItems;
  final Function(Item) onAddItem;
  final Function(String) onDeleteItem;

  const MyListingsScreen({
    super.key,
    required this.myItems,
    required this.onAddItem,
    required this.onDeleteItem,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои объявления'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/my/add'),
        child: const Icon(Icons.add),
      ),
      body: myItems.isEmpty
          ? const Center(child: Text('У вас пока нет объявлений'))
          : ItemTable(items: myItems, onDelete: onDeleteItem),
    );
  }
}