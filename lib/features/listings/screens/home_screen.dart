import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/item.dart';
import 'item_detail_screen.dart';
import '../widgets/item_table.dart';
import '../../categories/screens/categories_screen.dart';
import '../../addresses/screens/addresses_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../screens/my_listings_screen.dart';
import '../../auth/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Item> _allItems = [];
  List<Item> _userItems = [];

  @override
  void initState() {
    super.initState();
    _initializeDemoData();
  }

  void _initializeDemoData() {
    _allItems.addAll([
      Item(
        id: '1',
        title: 'Настольная лампа',
        description: 'Современная настольная лампа в хорошем состоянии',
        forExchange: false,
        owner: 'Алексей',
        imagePath: 'https://cdn1.ozone.ru/s3/multimedia-c/6397661772.jpg',
      ),
      Item(
        id: '2',
        title: 'Кресло',
        description: 'Мягкое офисное кресло, возможен обмен',
        forExchange: true,
        owner: 'Ирина',
        imagePath: 'https://avatars.mds.yandex.net/get-mpic/12366926/2a00000193f6a60316c7671dbd7ce04821a8/orig',
      ),
      Item(
        id: '3',
        title: 'Полка для книг',
        description: 'Деревянная полка, отличное состояние',
        forExchange: false,
        owner: 'Михаил',
        imagePath: 'https://avatars.mds.yandex.net/i?id=86d5887e8ef7cbf34155b28dc5aac7b5_l-4483413-images-thumbs&n=13',
      ),
      Item(
        id: '4',
        title: 'Кофеварка',
        description: 'Рабочая, отдам даром',
        forExchange: false,
        owner: 'Ольга',
        imagePath: 'https://avatars.mds.yandex.net/get-mpic/5313421/img_id5674444383649941535.jpeg/orig',
      ),
      Item(
        id: '5',
        title: 'Монитор',
        description: '24 дюйма, немного потерто, работает отлично',
        forExchange: true,
        owner: 'Павел',
        imagePath: 'https://avatars.mds.yandex.net/i?id=df9f7f4bb3c0035b0ef5f4ddb58bd6f0_l-3708982-images-thumbs&n=13',
      ),
    ]);
  }

  void _addMyItem(Item item) {
    setState(() {
      _userItems.add(item);
      _allItems.add(item);
    });
  }

  void _removeMyItem(String id) {
    setState(() {
      _userItems.removeWhere((it) => it.id == id);
      _allItems.removeWhere((it) => it.id == id);
    });
  }

  void _updateMyItems(List<Item> updatedItems) {
    setState(() {
      _userItems = updatedItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    const bannerUrl = 'https://avatars.mds.yandex.net/i?id=35a7ecfd8db436726cbcd80a3bc2b439dfb2708f-10555242-images-thumbs&ref=rim&n=33&w=480&h=224';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Объявления соседей'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
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
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  ),
                  child: const Text('Профиль'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CategoriesScreen()),
                  ),
                  child: const Text('Категории'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AddressesScreen()),
                  ),
                  child: const Text('Адреса'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MyListingsScreen(
                        myItems: _userItems,
                        onAdd: _addMyItem,
                        onDelete: _removeMyItem,
                        onUpdateMyItems: _updateMyItems,
                      ),
                    ),
                  ),
                  child: const Text('Мои объявления'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ItemTable(
              items: _allItems,
              onTap: (item) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ItemDetailScreen(item: item),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}