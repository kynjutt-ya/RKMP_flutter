import 'package:flutter/material.dart';

class RepairUpcycleScreen extends StatelessWidget {
  const RepairUpcycleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ремонт и апсайклинг')),
      body: const Center(child: Text('Список сервисов и обмен опыта по ремонту/апсайклингу')),
    );
  }
}
