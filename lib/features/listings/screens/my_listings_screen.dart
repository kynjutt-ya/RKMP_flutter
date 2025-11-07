import 'package:flutter/material.dart';
import '../models/item.dart';
import 'add_item_screen.dart';
import '../widgets/item_table.dart';

class MyListingsScreen extends StatefulWidget {
  final List<Item> myItems;
  final Function(Item) onAdd;
  final Function(String) onDelete;
  final Function(List<Item>) onUpdateMyItems;

  const MyListingsScreen({
    super.key,
    required this.myItems,
    required this.onAdd,
    required this.onDelete,
    required this.onUpdateMyItems,
  });

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои объявления'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddItemScreen(
                ownerName: 'Вы',
                myItems: widget.myItems,
                onUpdateMyItems: widget.onUpdateMyItems,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: widget.myItems.isEmpty
          ? const Center(child: Text('У вас пока нет объявлений'))
          : ItemTable(items: widget.myItems, onDelete: widget.onDelete),
    );
  }
}