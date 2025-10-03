import 'package:flutter/material.dart';
import '../models/item.dart';

class MyListingsScreen extends StatefulWidget {
  final List<Item> items;
  final void Function(String) onDelete;
  const MyListingsScreen({super.key, required this.items, required this.onDelete});

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  @override
  Widget build(BuildContext context) {
    final myItems = widget.items.where((it) => it.owner == 'Вы').toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Мои объявления')),
      body: myItems.isEmpty
          ? const Center(child: Text('У вас пока нет объявлений'))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: myItems.length,
        itemBuilder: (context, i) {
          final it = myItems[i];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              title: Text(it.title),
              subtitle: Text(it.description, maxLines: 2, overflow: TextOverflow.ellipsis),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Удалить объявление?'),
                      content: Text('Удалить "${it.title}"?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Отмена')),
                        TextButton(
                          onPressed: () {
                            widget.onDelete(it.id);
                            Navigator.of(ctx).pop();
                            setState(() {});
                          },
                          child: const Text('Удалить'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
