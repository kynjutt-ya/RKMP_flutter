import 'package:flutter/material.dart';

class EcoImpactScreen extends StatelessWidget {
  const EcoImpactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Экологический след')),
      body: const Center(child: Text('Здесь будет EcoImpact Dashboard и Achievements')),
    );
  }
}
