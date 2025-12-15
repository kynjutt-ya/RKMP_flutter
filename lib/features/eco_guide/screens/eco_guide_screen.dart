import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/eco_guide_cubit.dart';

class EcoGuideScreen extends StatefulWidget {
  const EcoGuideScreen({super.key});

  @override
  State<EcoGuideScreen> createState() => _EcoGuideScreenState();
}

class _EcoGuideScreenState extends State<EcoGuideScreen> {
  final _searchController = TextEditingController();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _linksTitleController = TextEditingController();
  final _imagesTitleController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    _titleController.dispose();
    _categoryController.dispose();
    _linksTitleController.dispose();
    _imagesTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Эко-гид / Утилизация')),
      body: BlocBuilder<EcoGuideCubit, EcoGuideState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wikipedia API - Экология и переработка',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                
                // 1. Поиск статей по запросу
                _buildSearchSection(context, state),
                const SizedBox(height: 16),
                
                // 2. Получение содержимого статьи
                _buildGetPageContentSection(context, state),
                const SizedBox(height: 16),
                
                // 3. Получение статей из категории
                _buildCategorySection(context, state),
                const SizedBox(height: 16),
                
                // 4. Получение связанных статей
                _buildLinksSection(context, state),
                const SizedBox(height: 16),
                
                // 5. Получение изображений статьи
                _buildImagesSection(context, state),
                const SizedBox(height: 16),
                
                // Результаты
                if (state.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (state.error != null)
                  _buildErrorCard(state.error!)
                else if (state.tipsList.isNotEmpty)
                  _buildResultsSection(state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchSection(BuildContext context, EcoGuideState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1. Поиск статей по запросу',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Например: переработка отходов',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_searchController.text.isNotEmpty) {
                      context.read<EcoGuideCubit>().searchWikipediaArticles(
                        _searchController.text,
                        limit: 5,
                      );
                    }
                  },
                  child: const Text('Найти'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGetPageContentSection(BuildContext context, EcoGuideState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '2. Получение содержимого статьи',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'Например: Переработка отходов',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_titleController.text.isNotEmpty) {
                      context.read<EcoGuideCubit>().getWikipediaPageContent(
                        _titleController.text,
                      );
                    }
                  },
                  child: const Text('Загрузить'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, EcoGuideState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '3. Получение статей из категории',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _categoryController,
                    decoration: const InputDecoration(
                      hintText: 'Например: Экология',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_categoryController.text.isNotEmpty) {
                      context.read<EcoGuideCubit>().getWikipediaCategoryArticles(
                        _categoryController.text,
                        limit: 10,
                      );
                    }
                  },
                  child: const Text('Загрузить'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinksSection(BuildContext context, EcoGuideState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '4. Получение связанных статей',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Введите название статьи, чтобы найти связанные с ней статьи',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _linksTitleController,
                    decoration: const InputDecoration(
                      hintText: 'Например: Экология',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_linksTitleController.text.isNotEmpty) {
                      context.read<EcoGuideCubit>().getWikipediaPageLinks(
                        _linksTitleController.text,
                        limit: 10,
                      );
                    }
                  },
                  child: const Text('Найти'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              '💡 Совет: Сначала найдите статью через "Поиск статей по запросу", затем используйте её название здесь',
              style: TextStyle(fontSize: 11, color: Colors.blue, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagesSection(BuildContext context, EcoGuideState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '5. Получение изображений статьи',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _imagesTitleController,
                    decoration: const InputDecoration(
                      hintText: 'Например: Переработка отходов',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_imagesTitleController.text.isNotEmpty) {
                      context.read<EcoGuideCubit>().getWikipediaPageImages(
                        _imagesTitleController.text,
                        limit: 10,
                      );
                    }
                  },
                  child: const Text('Загрузить'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(String error) {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.error, color: Colors.red),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                error,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsSection(EcoGuideState state) {
    return Builder(
      builder: (context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Результаты (${state.tipsList.length})',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ...state.tipsList.map((tip) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: tip.imageUrl != null
                      ? Image.network(
                          tip.imageUrl!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.article),
                        )
                      : const Icon(Icons.article),
                  title: Text(tip.title),
                  subtitle: Text(
                    tip.content,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.link),
                    tooltip: 'Найти связанные статьи',
                    onPressed: () {
                      // Автоматически заполняем поле и ищем связанные статьи
                      _linksTitleController.text = tip.title;
                      context.read<EcoGuideCubit>().getWikipediaPageLinks(
                        tip.title,
                        limit: 10,
                      );
                    },
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
