import 'package:flutter/material.dart';
import '../models/item.dart';
import 'add_item_screen.dart';
import '../widgets/item_table.dart';
import 'package:go_router/go_router.dart';

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
  int _currentIndex = 1;

  void _addItem(Item item) {
    widget.onAdd(item);
  }

  void _removeItem(String id) {
    widget.onDelete(id);
  }

  void _navigateTo(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
    String location;
    switch (index) {
      case 0: location = '/'; break;
      case 1: location = '/my'; break;
      case 2: location = '/categories'; break;
      case 3: location = '/addresses'; break;
      case 4: location = '/profile'; break;
      default: location = '/my'; break;
    }
    context.go(location);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Мои объявления')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push('/my/add');
        },
        child: const Icon(Icons.add),
      ),
      body: widget.myItems.isEmpty
          ? const Center(
        child: Text('У вас пока нет объявлений', style: TextStyle(color: Colors.grey)),
      )
          : ItemTable(
        items: widget.myItems,
        onDelete: _removeItem,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _navigateTo,
        selectedItemColor: theme.primaryColor,
        unselectedItemColor: theme.unselectedWidgetColor,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Мои'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Категории'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Адреса'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
      ),
    );
  }
}