import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../service_locator.dart';
import '../models/item.dart';
import '../widgets/item_table.dart';

class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({super.key});

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  late List<Item> _items;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    if (locator.isRegistered<AppStateService>()) {
      final appStateService = locator.get<AppStateService>();
      _items = List.from(appStateService.userItems);
    } else {
      print('Ошибка: AppStateService не зарегистрирован в GetIt!');
      _items = [];
    }
  }

  void _refresh() {
    setState(() {
      _loadData();
    });
  }

  void _deleteItem(String id) {
    if (locator.isRegistered<AppStateService>()) {
      final appStateService = locator.get<AppStateService>();
      appStateService.removeItem(id);
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои объявления'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/my/add').then((_) => _refresh()),
        child: const Icon(Icons.add),
      ),
      body: _items.isEmpty
          ? const Center(child: Text('У вас пока нет объявлений'))
          : ItemTable(
        items: _items,
        onDelete: (id) => _deleteItem(id),
        onTap: (it) => context.push('/item/${it.id}'),
      ),
    );
  }
}