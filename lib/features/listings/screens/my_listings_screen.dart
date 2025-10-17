import 'dart:io';
import 'package:flutter/material.dart';
import '../models/item.dart';
import 'add_item_screen.dart';
import '../widgets/item_table.dart';

class MyListingsScreen extends StatefulWidget {
  final List<Item> myItems;
  final Function(Item) onAdd;
  final Function(String) onDelete;

  const MyListingsScreen({
    super.key,
    required this.myItems,
    required this.onAdd,
    required this.onDelete,
  });

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  late List<Item> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.myItems);
  }

  void _addItem(Item item) {
    setState(() => _items.add(item));
    widget.onAdd(item);
  }

  void _removeItem(String id) {
    setState(() => _items.removeWhere((i) => i.id == id));
    widget.onDelete(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Мои объявления')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newItem = await Navigator.push<Item>(
            context,
            MaterialPageRoute(
              builder: (_) => AddItemScreen(
                ownerName: 'Вы',
                onAdd: _addItem,
              ),
            ),
          );
          if (newItem != null) _addItem(newItem);
        },
        child: const Icon(Icons.add),
      ),
      body: _items.isEmpty
          ? const Center(
        child: Text(
          'У вас пока нет объявлений',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ItemTable(
        items: _items,
        onDelete: _removeItem,
      ),
    );
  }
}
