import 'package:flutter/material.dart';

class EcoGuideScreen extends StatelessWidget {
  const EcoGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Эко-гид / Утилизация')),
      body: const Center(child: Text('Эко-гид: здесь будет контент по утилизации')),
    );
  }
}
