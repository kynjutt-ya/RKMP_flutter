import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/analytics_cubit.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnalyticsCubit>().recordScreenView('analytics_screen');
    });

    return const _AnalyticsScreenContent();
  }
}

class _AnalyticsScreenContent extends StatelessWidget {
  const _AnalyticsScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Статистика'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<AnalyticsCubit>().resetStatistics(),
            tooltip: 'Сбросить статистику',
          ),
        ],
      ),
      body: BlocBuilder<AnalyticsCubit, AnalyticsState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildStatCard('Всего сессий', state.totalSessions.toString()),
              _buildStatCard('Просмотрено экранов', state.screenViews.length.toString()),
              _buildStatCard('Просмотрено объявлений', state.itemViews.length.toString()),
              _buildStatCard('Поисковых запросов', state.searchQueries.length.toString()),

              const SizedBox(height: 20),
              const Text('Популярные экраны:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ..._getTopItems(state.screenViews),

              const SizedBox(height: 20),
              const Text('Популярные поисковые запросы:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ..._getTopItems(state.searchQueries),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Text(title, style: const TextStyle(fontSize: 16)),
            const Spacer(),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  List<Widget> _getTopItems(Map<String, int> items) {
    final sorted = items.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(5).map((entry) =>
        ListTile(
          title: Text(entry.key),
          trailing: Text('${entry.value}'),
        )
    ).toList();
  }
}