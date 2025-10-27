import 'package:flutter/material.dart';
import '../models/item.dart';
import 'add_item_screen.dart';
import 'home_screen.dart'; // ← из того же каталога
import '../../categories/screens/categories_screen.dart';
import '../../addresses/screens/addresses_screen.dart';
import '../../profile/screens/profile_screen.dart';

class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({super.key});

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  final List<Item> _items = [];

  void _addItem(Item item) {
    setState(() => _items.add(item));
  }

  void _navigateTo(int index) {
    if (index == 1) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) {
        switch (index) {
          case 0: return const HomeScreen();
          case 2: return const CategoriesScreen();
          case 3: return const AddressesScreen();
          case 4: return const ProfileScreen();
          default: return const MyListingsScreen();
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Мои объявления')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newItem = await Navigator.of(context).push<Item>(
            MaterialPageRoute(
              builder: (context) => AddItemScreen(ownerName: 'Вы', onAdd: _addItem),
            ),
          );
          if (newItem != null) _addItem(newItem);
        },
        child: const Icon(Icons.add),
      ),
      body: _items.isEmpty
          ? const Center(child: Text('У вас пока нет объявлений'))
          : ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, i) => ListTile(
          title: Text(_items[i].title),
          subtitle: Text(_items[i].description),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => setState(() => _items.removeAt(i)),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: _navigateTo,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
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