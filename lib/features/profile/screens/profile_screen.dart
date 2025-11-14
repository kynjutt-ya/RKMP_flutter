import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const profileUrl = 'https://picsum.photos/seed/profile/200/200';

    return Scaffold(
      appBar: AppBar(title: const Text('Профиль пользователя'), leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop())),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          CircleAvatar(
            radius: 56,
            backgroundImage: CachedNetworkImageProvider(profileUrl),
          ),
          const SizedBox(height: 16),
          const Text('Вы', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text('user@example.com', style: TextStyle(color: Colors.grey)),
        ]),
      ),
    );
  }
}
