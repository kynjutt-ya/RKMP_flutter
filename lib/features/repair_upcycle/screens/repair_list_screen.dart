// lib/features/repair_upcycle/screens/repair_list_screen.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../auth/cubit/auth_cubit.dart';
import '../cubit/repair_cubit.dart';
import '../models/repair_service.dart';
import '../../../shared/image_helper.dart';

// lib/features/repair_upcycle/screens/request_repair_screen.dart

class RepairListScreen extends StatelessWidget {
  const RepairListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('Ремонт и апсайклинг'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/listings'),
          ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/repair/request'),
            tooltip: 'Создать запрос',
          ),
        ],
        ),
      body: BlocBuilder<RepairCubit, RepairState>(
        builder: (context, state) {
          if (state.allServices.isEmpty) {
            return const Center(
              child: Text('Сервисы загружаются...'),
            );
          }

          return Column(
            children: [
              _buildCategoryFilters(context, state),
              Expanded(
                child: state.services.isEmpty
                    ? const Center(
                        child: Text('Нет сервисов в выбранной категории'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: state.services.length,
                        itemBuilder: (context, index) {
                          final service = state.services[index];
                          return _buildServiceCard(context, service);
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/repair/request'),
        icon: const Icon(Icons.add),
        label: const Text('Создать запрос'),
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, RepairService service) {
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
                Expanded(
                  child: Text(
                    service.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      service.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text(_getCategoryLabel(service.category)),
              backgroundColor: Colors.blue[50],
            ),
            const SizedBox(height: 12),
            Text(
              service.description,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (service.priceFrom != null) ...[
                  const Icon(Icons.attach_money, size: 16, color: Colors.green),
                  const SizedBox(width: 4),
                  Text(
                    'От ${service.priceFrom!.toStringAsFixed(0)} ₽',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                const Icon(Icons.phone, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  service.contact,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                context.read<RepairCubit>().loadPortfolio(service.id);
                // В будущем можно открыть детальный экран мастера
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Профиль ${service.name}'),
                    action: SnackBarAction(
                      label: 'Связаться',
                      onPressed: () {
                        // Здесь можно открыть чат или телефон
                      },
                    ),
                  ),
                );
              },
              child: const Text('Связаться'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilters(BuildContext context, RepairState state) {
    final theme = Theme.of(context);
    const categories = ['furniture', 'electronics', 'textile'];
    
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ChoiceChip(
            label: const Text('Все'),
            selected: state.selectedCategory == null,
            onSelected: (_) {
              context.read<RepairCubit>().clearFilters();
            },
            selectedColor: theme.colorScheme.primary.withOpacity(0.2),
            labelStyle: TextStyle(
              color: state.selectedCategory == null
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface,
              fontWeight: state.selectedCategory == null
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
          const SizedBox(width: 8),
          ...categories.map((category) {
            final isSelected = state.selectedCategory == category;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(_getCategoryLabel(category)),
                selected: isSelected,
                onSelected: (_) {
                  // Если уже выбрана - снимаем фильтр, иначе устанавливаем
                  if (isSelected) {
                    context.read<RepairCubit>().clearFilters();
                  } else {
                    context.read<RepairCubit>().loadServices(category: category);
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

  String _getCategoryLabel(String category) {
    const labels = {
      'furniture': 'Мебель',
      'electronics': 'Электроника',
      'textile': 'Текстиль',
    };
    return labels[category] ?? category;
  }
}

class RequestRepairScreen extends StatefulWidget {
  const RequestRepairScreen({super.key});

  @override
  State<RequestRepairScreen> createState() => _RequestRepairScreenState();
}

class _RequestRepairScreenState extends State<RequestRepairScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  String _selectedCategory = 'furniture';
  XFile? _pickedImage;
  Uint8List? _pickedImageBytes;
  File? _pickedImageFile;

  static const List<String> categories = ['furniture', 'electronics', 'textile'];

  @override
  void dispose() {
    _descriptionCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImageHelper.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await ImageHelper.getImageBytes(picked);
      setState(() {
        _pickedImage = picked;
        _pickedImageBytes = bytes;
        if (!kIsWeb) {
          _pickedImageFile = File(picked.path);
        }
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final authState = context.read<AuthCubit>().state;
    final userId = authState.userEmail ?? 'guest_${DateTime.now().millisecondsSinceEpoch}';

    context.read<RepairCubit>().createRepairRequest(
          userId: userId,
          category: _selectedCategory,
          description: _descriptionCtrl.text.trim(),
          imageUrl: kIsWeb ? null : _pickedImage?.path,
          proposedPrice: _priceCtrl.text.trim().isNotEmpty
              ? double.tryParse(_priceCtrl.text.trim())
              : null,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Запрос на ремонт создан!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Создать запрос на ремонт'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Категория',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: categories.map((cat) {
                  const labels = {
                    'furniture': 'Мебель',
                    'electronics': 'Электроника',
                    'textile': 'Текстиль',
                  };
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(labels[cat] ?? cat),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _selectedCategory = value);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionCtrl,
                decoration: const InputDecoration(
                  labelText: 'Описание проблемы *',
                  border: OutlineInputBorder(),
                  hintText: 'Опишите, что нужно починить...',
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Введите описание проблемы';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceCtrl,
                decoration: const InputDecoration(
                  labelText: 'Предложенная цена (опционально)',
                  border: OutlineInputBorder(),
                  hintText: '0',
                  prefixText: '₽ ',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              const Text(
                'Фото (опционально)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _pickedImage != null
                  ? Stack(
                      children: [
                        ImageHelper.buildImageWidget(
                          imageFile: _pickedImageFile,
                          imageBytes: _pickedImageBytes,
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => setState(() {
                              _pickedImage = null;
                              _pickedImageBytes = null;
                              _pickedImageFile = null;
                            }),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(Icons.image, size: 48, color: Colors.grey),
                      ),
                    ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo),
                label: const Text('Выбрать фото'),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Создать запрос'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
