import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../service_locator.dart';
import '../models/item.dart';
import '../widgets/item_table.dart';

class MyListingsScreen extends StatefulWidget {
  final Function(Item) onAddItem;
  final Function(String) onDeleteItem;

  const MyListingsScreen({super.key, required this.onAddItem, required this.onDeleteItem});

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  late final AppStateService _service;
  late List<Item> _items;

  @override
  void initState() {
    super.initState();
    _service = locator<AppStateService>();
    _items = List.from(_service.userItems);
  }

  void _refresh() {
    setState(() {
      _items = List.from(_service.userItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои объявления'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/my/add').then((_) => _refresh()),
        child: const Icon(Icons.add),
      ),
      body: _items.isEmpty
          ? const Center(child: Text('У вас пока нет объявлений'))
          : ItemTable(
        items: _items,
        onDelete: (id) {
          widget.onDeleteItem(id);
          _refresh();
        },
        onTap: (it) => context.push('/item/${it.id}'),
      ),
    );
  }
}
