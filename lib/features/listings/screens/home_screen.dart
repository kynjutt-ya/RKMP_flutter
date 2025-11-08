import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../models/item.dart';
import '../widgets/item_table.dart';

class HomeScreen extends StatelessWidget {
  final List<Item> allItems;
  final List<Item> userItems;
  final Function(Item) onAddItem;
  final Function(String) onDeleteItem;

  const HomeScreen({
    super.key,
    required this.allItems,
    required this.userItems,
    required this.onAddItem,
    required this.onDeleteItem,
  });

  @override
  Widget build(BuildContext context) {
    const bannerUrl = 'https://avatars.mds.yandex.net/i?id=35a7ecfd8db436726cbcd80a3bc2b439dfb2708f-10555242-images-thumbs&ref=rim&n=33&w=480&h=224';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Объявления соседей'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.go('/login'),
          ),
        ],
      ),
      body: Column(
        children: [
          CachedNetworkImage(
            imageUrl: bannerUrl,
            width: double.infinity,
            height: 180,
            fit: BoxFit.cover,
            progressIndicatorBuilder: (context, url, progress) =>
            const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
            const Center(child: Icon(Icons.error, color: Colors.red)),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => context.push('/profile'),
                  child: const Text('Профиль'),
                ),
                ElevatedButton(
                  onPressed: () => context.push('/categories'),
                  child: const Text('Категории'),
                ),
                ElevatedButton(
                  onPressed: () => context.push('/addresses'),
                  child: const Text('Адреса'),
                ),
                ElevatedButton(
                  onPressed: () => context.push('/my'),
                  child: const Text('Мои объявления'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ItemTable(
              items: allItems,
              onTap: (item) => context.push('/item/${item.id}'),
            ),
          ),
        ],
      ),
    );
  }
}