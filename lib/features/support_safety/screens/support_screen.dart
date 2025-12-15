import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Поддержка и безопасность'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/listings'),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
          Card(
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.report, color: Colors.red),
              title: const Text('Сообщить о проблеме'),
              subtitle: const Text('Создать тикет в службу поддержки'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => context.push('/support/report'),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.blue),
              title: const Text('FAQ'),
              subtitle: const Text('Часто задаваемые вопросы и советы'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => context.push('/support/faq'),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.confirmation_number, color: Colors.green),
              title: const Text('Мои тикеты'),
              subtitle: const Text('Статусы всех обращений'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => context.push('/support/tickets'),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            color: Colors.blue[50],
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.security, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'Безопасность',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    '• Встречайтесь в публичных местах\n'
                    '• Проверяйте вещи перед оплатой\n'
                    '• Сообщайте о подозрительных объявлениях',
                    style: TextStyle(fontSize: 14, height: 1.5),
            ),
          ],
        ),
            ),
          ),
        ],
      ),
    );
  }
}
