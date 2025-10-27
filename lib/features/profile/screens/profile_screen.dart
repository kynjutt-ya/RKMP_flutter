import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Импорты для навигации
import '../../listings/screens/home_screen.dart';
import '../../listings/screens/my_listings_screen.dart';
import '../../categories/screens/categories_screen.dart';
import '../../addresses/screens/addresses_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _navigateTo(BuildContext context, int index) {
    if (index == 4) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) {
        switch (index) {
          case 0: return HomeScreen();
          case 1: return MyListingsScreen();
          case 2: return CategoriesScreen();
          case 3: return AddressesScreen();
          default: return ProfileScreen();
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    const _profileImageUrl = 'https://avatars.mds.yandex.net/i?id=b48403d08e60a0510b2b3ecd065c6a91_l-4238543-images-thumbs&n=13';

    return Scaffold(
      appBar: AppBar(title: const Text('Профиль пользователя')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CachedNetworkImage(
              imageUrl: _profileImageUrl,
              progressIndicatorBuilder: (context, url, progress) =>
              const CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
              const Icon(Icons.error, color: Colors.red),
              imageBuilder: (context, imageProvider) => CircleAvatar(
                radius: 60,
                backgroundImage: imageProvider,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Вы',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'user@example.com',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4,
        onTap: (index) => _navigateTo(context, index),
        selectedItemColor: Colors.teal,
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