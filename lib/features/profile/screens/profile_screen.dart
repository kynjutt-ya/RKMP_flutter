import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль пользователя'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 56,
              backgroundImage: AssetImage('assets/placeholder.png'),
            ),
            const SizedBox(height: 16),
            const Text('Вы', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text('user@example.com', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}