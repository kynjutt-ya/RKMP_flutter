// lib/features/eco_guide/screens/eco_tips_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/eco_guide_cubit.dart';

// lib/features/eco_guide/screens/recycling_guide_screen.dart
// lib/features/eco_guide/screens/recycling_map_screen.dart

class EcoTipsScreen extends StatefulWidget {
  const EcoTipsScreen({super.key});

  @override
  State<EcoTipsScreen> createState() => _EcoTipsScreenState();
}

class _EcoTipsScreenState extends State<EcoTipsScreen> {
  final _searchController = TextEditingController();
  bool _showWikipediaResults = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Эко-гид'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/listings'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () => context.push('/eco-guide/map'),
            tooltip: 'Карта пунктов приёма',
          ),
          IconButton(
            icon: const Icon(Icons.recycling),
            onPressed: () => context.push('/eco-guide/recycling-guide'),
            tooltip: 'Руководство по переработке',
          ),
        ],
      ),
      body: BlocListener<EcoGuideCubit, EcoGuideState>(
        listener: (context, state) {
          if (state.tipsList.isNotEmpty && _searchController.text.isNotEmpty) {
            setState(() {
              _showWikipediaResults = true;
            });
          }
        },
        child: BlocBuilder<EcoGuideCubit, EcoGuideState>(
          builder: (context, state) {
            return Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.search, color: Colors.green),
                            const SizedBox(width: 8),
                            const Text(
                              'Поиск информации об экологии',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: const InputDecoration(
                                  hintText: 'Например: переработка отходов, экология',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.article),
                                ),
                                onSubmitted: (query) {
                                  if (query.isNotEmpty) {
                                    context.read<EcoGuideCubit>().searchWikipediaArticles(
                                          query,
                                          limit: 5,
                                        );
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: state.isLoading
                                  ? null
                                  : () {
                                      if (_searchController.text.isNotEmpty) {
                                        context.read<EcoGuideCubit>().searchWikipediaArticles(
                                              _searchController.text,
                                              limit: 5,
                                            );
                                      }
                                    },
                              icon: state.isLoading
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Icon(Icons.search),
                              label: const Text('Найти'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Результаты поиска Wikipedia или обычные советы
                Expanded(
                  child: _showWikipediaResults && state.tipsList.isNotEmpty
                      ? _buildWikipediaResults(context, state)
                      : state.tipsList.isEmpty
                          ? const Center(
                              child: Text('Советы загружаются...'),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: state.tipsList.length,
                              itemBuilder: (context, index) {
                                final tip = state.tipsList[index];
                                return _buildTipCard(tip, context);
                              },
                            ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildWikipediaResults(BuildContext context, EcoGuideState state) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: state.tipsList.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Card(
            color: Colors.green[50],
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.article, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Найдено ${state.tipsList.length} статей из Wikipedia',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _showWikipediaResults = false;
                        _searchController.clear();
                      });
                    },
                    child: const Text('Показать советы'),
                  ),
                ],
              ),
            ),
          );
        }
        final tip = state.tipsList[index - 1];
        return _buildWikipediaCard(tip, context);
      },
    );
  }

  Widget _buildWikipediaCard(EcoTip tip, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: InkWell(
        onTap: () {
          // Запрос 2: getPageContent - получение содержимого статьи
          context.read<EcoGuideCubit>().getWikipediaPageContent(tip.title);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.article, color: Colors.blue),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      tip.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.link),
                    tooltip: 'Связанные статьи',
                    onPressed: () {
                      // Запрос 4: getPageLinks - получение связанных статей
                      context.read<EcoGuideCubit>().getWikipediaPageLinks(
                            tip.title,
                            limit: 10,
                          );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                tip.content,
                style: const TextStyle(fontSize: 14, height: 1.5),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                'Нажмите, чтобы прочитать статью полностью',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue[700],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipCard(EcoTip tip, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.eco, color: Colors.green),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    tip.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              tip.content,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 8),
            Text(
              _formatDate(tip.createdAt),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}

class RecyclingGuideScreen extends StatelessWidget {
  const RecyclingGuideScreen({super.key});

  static const Map<String, Map<String, dynamic>> categoryGuides = {
    'furniture': {
      'title': 'Мебель',
      'icon': Icons.chair,
      'steps': [
        'Проверьте состояние: можно ли отремонтировать или переделать?',
        'Отдайте через приложение соседям или на благотворительность',
        'Если мебель не подлежит использованию, разберите на части',
        'Деревянные части можно сдать в пункты приёма дерева',
        'Металлические части сдайте в пункты приёма металла',
        'Остальное вывозите на специальные полигоны, не в обычный мусор',
      ],
    },
    'electronics': {
      'title': 'Электроника',
      'icon': Icons.devices,
      'steps': [
        'Попробуйте продать или отдать через приложение',
        'Сдайте в специальные пункты приёма электроники',
        'Крупные магазины часто принимают старую технику при покупке новой',
        'Батарейки и аккумуляторы сдавайте отдельно в специальные контейнеры',
        'Никогда не выбрасывайте электронику в обычный мусор!',
      ],
    },
    'clothing': {
      'title': 'Одежда и текстиль',
      'icon': Icons.checkroom,
      'steps': [
        'Хорошую одежду отдайте через приложение или в благотворительные организации',
        'Повреждённую одежду можно переработать в тряпки',
        'Специальные контейнеры для текстиля принимают любую одежду',
        'Некоторые магазины принимают старую одежду на переработку',
        'Текстиль можно использовать для утепления или переработки в новые материалы',
      ],
    },
    'plastic': {
      'title': 'Пластик',
      'icon': Icons.water_drop,
      'steps': [
        'Проверьте маркировку: какие виды пластика принимаются в вашем районе',
        'Промойте и высушите перед сдачей',
        'Сдавайте в контейнеры для раздельного сбора',
        'Пластиковые бутылки можно сдать в пункты приёма за деньги',
        'Избегайте одноразового пластика в будущем',
      ],
    },
    'batteries': {
      'title': 'Батарейки',
      'icon': Icons.battery_charging_full,
      'steps': [
        'Никогда не выбрасывайте батарейки в обычный мусор!',
        'Собирайте все использованные батарейки отдельно',
        'Сдавайте в специальные контейнеры в магазинах или пунктах приёма',
        'Одна батарейка может загрязнить 20 м² почвы',
        'Переработанные батарейки дают ценные металлы',
      ],
    },
    'paper': {
      'title': 'Бумага и картон',
      'icon': Icons.description,
      'steps': [
        'Удалите скотч, плёнку и другие небумажные элементы',
        'Сдавайте в контейнеры для макулатуры',
        'Многие пункты приёма платят за макулатуру',
        'Бумага перерабатывается до 7 раз',
        '1 тонна макулатуры спасает 17 деревьев',
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Руководство по переработке'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<EcoGuideCubit, EcoGuideState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Выберите категорию',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ...categoryGuides.entries.map((entry) {
                  final category = entry.key;
                  final guide = entry.value;
                  final isSelected = state.selectedCategory == category;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    color: isSelected ? Colors.blue[50] : null,
                    child: InkWell(
                      onTap: () {
                        context.read<EcoGuideCubit>().setCategory(category);
                        // Запрос 5: getPageImages - получение изображений статьи при выборе категории
                        final categoryMap = {
                          'furniture': 'Мебель',
                          'electronics': 'Электроника',
                          'clothing': 'Одежда',
                          'plastic': 'Пластик',
                          'batteries': 'Батарейки',
                          'paper': 'Бумага',
                        };
                        final categoryName = categoryMap[category] ?? 'Экология';
                        context.read<EcoGuideCubit>().getWikipediaPageImages(
                              categoryName,
                              limit: 5,
                            );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              guide['icon'] as IconData,
                              size: 32,
                              color: isSelected ? Colors.blue : Colors.grey,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                guide['title'] as String,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.blue : null,
                                ),
                              ),
                            ),
                            if (isSelected)
                              const Icon(Icons.check_circle, color: Colors.blue),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                if (state.selectedCategory.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  _buildGuideSteps(state.selectedCategory, context, state),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGuideSteps(String category, BuildContext context, EcoGuideState state) {
    final guide = categoryGuides[category];
    if (guide == null) return const SizedBox.shrink();

    final steps = guide['steps'] as List<String>;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  guide['icon'] as IconData,
                  size: 32,
                  color: Colors.green,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    guide['title'] as String,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            // Изображения из Wikipedia (запрос 5: getPageImages)
            if (state.tipsList.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Изображения:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.tipsList.length,
                  itemBuilder: (context, index) {
                    final tip = state.tipsList[index];
                    if (tip.imageUrl == null) return const SizedBox.shrink();
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          tip.imageUrl!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 24),
            const Text(
              'Шаги по переработке:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        step,
                        style: const TextStyle(fontSize: 14, height: 1.5),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class RecyclingMapScreen extends StatelessWidget {
  const RecyclingMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Пункты приёма'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Можно добавить информацию о фильтрах
            },
          ),
        ],
      ),
      body: BlocBuilder<EcoGuideCubit, EcoGuideState>(
        builder: (context, state) {
          if (state.recyclingPoints.isEmpty && state.selectedRecyclingFilter == null) {
            return const Center(
              child: Text('Пункты приёма загружаются...'),
            );
          }

          return Column(
            children: [
              _buildRecyclingFilters(context, state),
              Expanded(
                child: state.recyclingPoints.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.filter_alt_off, size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            const Text('Нет пунктов приёма для выбранного типа'),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => context.read<EcoGuideCubit>().clearRecyclingFilter(),
                              child: const Text('Сбросить фильтр'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: state.recyclingPoints.length,
                        itemBuilder: (context, index) {
                          final point = state.recyclingPoints[index];
                          return _buildPointCard(point);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPointCard(RecyclingPoint point) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.red, size: 28),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    point.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.place, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    point.address,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: point.acceptedTypes.map((type) {
                return Chip(
                  label: Text(_getTypeLabel(type)),
                  labelStyle: const TextStyle(fontSize: 12),
                  backgroundColor: Colors.green[50],
                );
              }).toList(),
            ),
            if (point.phone != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.phone, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    point.phone!,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
            if (point.website != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.language, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      point.website!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

      Widget _buildRecyclingFilters(BuildContext context, EcoGuideState state) {
        final theme = Theme.of(context);
        const filterTypes = [
          'paper',
          'plastic',
          'electronics',
          'clothing',
          'batteries',
        ];
        
        return Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ChoiceChip(
                label: const Text('Все типы'),
                selected: state.selectedRecyclingFilter == null,
                onSelected: (_) {
                  context.read<EcoGuideCubit>().clearRecyclingFilter();
                },
                selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                labelStyle: TextStyle(
                  color: state.selectedRecyclingFilter == null
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                  fontWeight: state.selectedRecyclingFilter == null
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              const SizedBox(width: 8),
              ...filterTypes.map((filterType) {
                final isSelected = state.selectedRecyclingFilter == filterType;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(_getTypeLabel(filterType)),
                    selected: isSelected,
                    onSelected: (_) {
                      // Если уже выбрана - снимаем фильтр, иначе устанавливаем
                      if (isSelected) {
                        context.read<EcoGuideCubit>().clearRecyclingFilter();
                      } else {
                        context.read<EcoGuideCubit>().loadRecyclingPoints(filter: filterType);
                      }
                    },
                    selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      }

      String _getTypeLabel(String type) {
        const labels = {
          'paper': 'Бумага',
          'plastic': 'Пластик',
          'glass': 'Стекло',
          'metal': 'Металл',
          'electronics': 'Электроника',
          'batteries': 'Батарейки',
          'clothing': 'Одежда',
          'textiles': 'Текстиль',
        };
        return labels[type] ?? type;
  }
}
