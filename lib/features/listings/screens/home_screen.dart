import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../models/item.dart';
import '../../../shared/app_state.dart';
import '../widgets/item_table.dart';

class HomeScreen extends StatelessWidget {
  final Function(Item) onAddItem;
  final Function(String) onDeleteItem;

  const HomeScreen({super.key, required this.onAddItem, required this.onDeleteItem});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final allItems = appState?.allItems ?? [];

    const bannerUrl = 'https://avatars.mds.yandex.net/i?id=35a7ecfd8db436726cbcd80a3bc2b439dfb2708f-10555242-images-thumbs&ref=rim&n=33&w=480&h=224';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Объявления соседей'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          CachedNetworkImage(
            imageUrl: bannerUrl,
            width: double.infinity,
            height: 180,
            fit: BoxFit.cover,
            progressIndicatorBuilder: (c, u, p) => const Center(child: CircularProgressIndicator()),
            errorWidget: (c, u, e) => const Center(child: Icon(Icons.error, color: Colors.red)),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(spacing: 8, runSpacing: 8, children: [
              ElevatedButton(onPressed: () => context.push('/profile'), child: const Text('Профиль')),
              ElevatedButton(onPressed: () => context.push('/categories'), child: const Text('Категории')),
              ElevatedButton(onPressed: () => context.push('/addresses'), child: const Text('Адреса')),
              ElevatedButton(onPressed: () => context.push('/my'), child: const Text('Мои объявления')),
            ]),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: allItems.isEmpty
                ? const Center(child: Text('Пока нет объявлений'))
                : ItemTable(
              items: allItems,
              onTap: (it) => context.push('/item/${it.id}'),
            ),
          ),
        ],
      ),
    );
  }
}
