import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final List<String> _categories = [];
  final _controller = TextEditingController();
  final String _bannerUrl = 'https://avatars.dzeninfra.ru/get-zen_doc/4162493/pub_63d2584ca2e35520b450a5ef_63d25857f342be623847d0dc/scale_1200';

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    _categories.addAll(prefs.getStringList('categories') ?? []);
    setState(() {});
  }

  Future<void> _saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('categories', _categories);
  }

  void _addCategory() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() => _categories.add(text));
    _controller.clear();
    _saveCategories();
  }

  void _removeCategory(String cat) {
    setState(() => _categories.remove(cat));
    _saveCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Категории товаров'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          CachedNetworkImage(
            imageUrl: _bannerUrl,
            height: 160,
            width: double.infinity,
            fit: BoxFit.cover,
            progressIndicatorBuilder: (context, url, progress) =>
            const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
            const Center(child: Icon(Icons.error, color: Colors.red)),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(labelText: 'Введите категорию'),
                  ),
                ),
                IconButton(icon: const Icon(Icons.add), onPressed: _addCategory),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _categories.isEmpty
                ? const Center(child: Text('Категорий пока нет'))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _categories.length,
              itemBuilder: (context, i) => ListTile(
                title: Text(_categories[i]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeCategory(_categories[i]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}