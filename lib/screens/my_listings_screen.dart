import 'dart:io';
import 'package:flutter/material.dart';
import '../models/item.dart';
import 'add_item_screen.dart';

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
    setState(() {
      _items.add(item);
    });
    widget.onAdd(item);
  }

  void _removeItem(String id) {
    setState(() {
      _items.removeWhere((i) => i.id == id);
    });
    widget.onDelete(id);
  }

  Widget _buildImage(String? path) {
    if (path == null) {
      return Image.asset('assets/placeholder.png',
          height: 80, width: 80, fit: BoxFit.cover);
    }
    if (path.startsWith('assets/')) {
      return Image.asset(path, height: 80, width: 80, fit: BoxFit.cover);
    }
    return Image.file(File(path), height: 80, width: 80, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Мои объявления')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddItemScreen(
                ownerName: 'Вы',
                onAdd: _addItem,
              ),
            ),
          );
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
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: _items.map((item) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                leading: _buildImage(item.imagePath),
                title: Text(item.title),
                subtitle: Text(item.description),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeItem(item.id),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
