import 'package:flutter/material.dart';
import 'shared/app_theme.dart';
import 'app_router.dart';
import 'features/listings/models/item.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Item> _allItems = [];
  final List<Item> _userItems = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final allItemsJson = prefs.getStringList('allItems') ?? [];
    final userItemsJson = prefs.getStringList('userItems') ?? [];

    setState(() {
      _allItems.clear();
      _userItems.clear();
      _initializeDemoDataIfEmpty();
    });
  }

  void _initializeDemoDataIfEmpty() {
    if (_allItems.isEmpty) {
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
  }

  void _addMyItem(Item item) {
    setState(() {
      _userItems.add(item);

      if (!_allItems.any((i) => i.id == item.id)) {
        _allItems.add(item);
      }
    });
    _saveData();
  }

  void _removeMyItem(String id) {
    setState(() {
      _userItems.removeWhere((it) => it.id == id);
      _allItems.removeWhere((it) => it.id == id);
    });
    _saveData();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

  }

  @override
  Widget build(BuildContext context) {
    final router = createAppRouter(_allItems, _userItems, _addMyItem, _removeMyItem);

    return MaterialApp.router(
      title: 'От соседей — мини-маркетплейс',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}