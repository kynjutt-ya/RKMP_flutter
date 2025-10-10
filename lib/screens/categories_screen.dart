import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final List<String> _categories = [];
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _categories.addAll(prefs.getStringList('categories') ?? []);
    });
  }

  Future<void> _saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('categories', _categories);
  }

  void _addCategory() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _categories.add(text);
    });
    _controller.clear();
    _saveCategories();
  }

  void _removeCategory(String category) {
    setState(() {
      _categories.remove(category);
    });
    _saveCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Категории товаров')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration:
                    const InputDecoration(labelText: 'Введите категорию'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addCategory,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _categories.isEmpty
                  ? const Center(child: Text('Категорий пока нет'))
                  : ListView.separated(
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, i) {
                  final cat = _categories[i];
                  return ListTile(
                    title: Text(cat),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeCategory(cat),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
