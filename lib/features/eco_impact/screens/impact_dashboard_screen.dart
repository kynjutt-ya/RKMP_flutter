// lib/features/eco_impact/screens/impact_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/eco_impact_cubit.dart';

class ImpactDashboardScreen extends StatelessWidget {
  const ImpactDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('Экологический след'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/listings'),
          ),
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events),
            onPressed: () => context.push('/impact/achievements'),
            tooltip: 'Достижения',
          ),
        ],
        ),
      body: BlocBuilder<EcoImpactCubit, EcoImpactState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ваш вклад в экологию',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                _buildStatCard(
                  context,
                  icon: Icons.inventory_2,
                  title: 'Вещей отдано',
                  value: '${state.totalItems}',
                  subtitle: 'шт.',
                  color: Colors.blue,
                ),
                const SizedBox(height: 16),
                _buildStatCard(
                  context,
                  icon: Icons.delete_outline,
                  title: 'Мусора спасено',
                  value: '${state.totalKgSaved.toStringAsFixed(1)}',
                  subtitle: 'кг',
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                _buildStatCard(
                  context,
                  icon: Icons.eco,
                  title: 'CO₂ сэкономлено',
                  value: '${state.totalCO2Saved.toStringAsFixed(1)}',
                  subtitle: 'кг',
                  color: Colors.orange,
                ),
                const SizedBox(height: 32),
                const Text(
                  'История',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (state.history.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          'Пока нет истории',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  )
                else
                  ...state.history.reversed.take(5).map((entry) => _buildHistoryEntry(entry)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => context.push('/impact/achievements'),
                  icon: const Icon(Icons.emoji_events),
                  label: const Text('Посмотреть достижения'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryEntry(ImpactHistory entry) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.history, color: Colors.blue),
        title: Text(
          '${entry.date.day}.${entry.date.month}.${entry.date.year}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Отдано: ${entry.itemsGiven} шт. | Спасено: ${entry.kgSaved.toStringAsFixed(1)} кг',
        ),
        trailing: Text(
          '${entry.co2Saved.toStringAsFixed(1)} кг CO₂',
          style: const TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
