import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _navigateTo(BuildContext context, int index) {
    String location;
    switch (index) {
      case 0: location = '/'; break;
      case 1: location = '/my'; break;
      case 2: location = '/categories'; break;
      case 3: location = '/addresses'; break;
      case 4: location = '/profile'; break;
      default: location = '/profile'; break;
    }
    context.go(location);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const _url = 'https://avatars.mds.yandex.net/i?id=b48403d08e60a0510b2b3ecd065c6a91_l-4238543-images-thumbs&n=13';

    return Scaffold(
      appBar: AppBar(title: const Text('Профиль пользователя')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: _url,
              progressIndicatorBuilder: (context, url, progress) =>
              const CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
              const Icon(Icons.error, color: Colors.red),
              imageBuilder: (context, imageProvider) => CircleAvatar(
                radius: 56,
                backgroundImage: imageProvider,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Вы',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              'user@mail.com',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4,
        onTap: (index) => _navigateTo(context, index),
        selectedItemColor: theme.primaryColor,
        unselectedItemColor: theme.unselectedWidgetColor,
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