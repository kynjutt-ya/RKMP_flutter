import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/item.dart';
import '../screens/my_listings_screen.dart';
import '../../categories/screens/categories_screen.dart';
import '../../addresses/screens/addresses_screen.dart';
import '../widgets/item_table.dart';
import '../screens/item_detail_screen.dart';
import '../../profile/screens/profile_screen.dart';
import 'dart:math';

class HomeContainer extends StatefulWidget {
  const HomeContainer({super.key});

  @override
  State<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  final List<Item> _allItems = [];
  final List<Item> _userItems = [];
  Item? _recentlyDeleted;

  int _currentIndex = 0;

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

  // --- Методы управления ---
  void _addMyItem(Item item) {
    setState(() {
      _userItems.add(item);
      _allItems.add(item);
    });
  }

  void _removeMyItem(String id) {
    final item = _allItems.firstWhere((it) => it.id == id, orElse: () => Item.empty());
    if (item.id.isEmpty) return;

    setState(() {
      _recentlyDeleted = item;
      _userItems.removeWhere((it) => it.id == id);
      _allItems.removeWhere((it) => it.id == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Объявление удалено'),
        action: SnackBarAction(
          label: 'Отменить',
          onPressed: _undoRemove,
        ),
      ),
    );
  }

  void _undoRemove() {
    if (_recentlyDeleted == null) return;
    setState(() {
      _userItems.add(_recentlyDeleted!);
      _allItems.add(_recentlyDeleted!);
      _recentlyDeleted = null;
    });
  }

  // --- Навигация между вкладками ---
  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MyListingsScreen(
              myItems: _userItems,
              onAdd: _addMyItem,
              onDelete: _removeMyItem,
            ),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CategoriesScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddressesScreen()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    const bannerUrl = 'https://avatars.mds.yandex.net/i?id=35a7ecfd8db436726cbcd80a3bc2b439dfb2708f-10555242-images-thumbs&ref=rim&n=33&w=480&h=224';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Объявления соседей'),
        centerTitle: true,
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
          const SizedBox(height: 8),
          Expanded(
            child: _allItems.isEmpty
                ? const Center(
              child: Text('Пока нет объявлений'),
            )
                : ItemTable(
              items: _allItems,
              onTap: (item) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ItemDetailScreen(item: item),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.blueAccent,
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
