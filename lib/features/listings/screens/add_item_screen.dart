import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../models/item.dart';
import '../cubit/listings_cubit.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../eco_impact/cubit/eco_impact_cubit.dart';
import '../../../shared/image_helper.dart';

class AddItemScreen extends StatefulWidget {
  final String ownerName;
  final Function(Item)? onAddItem;

  const AddItemScreen({super.key, required this.ownerName, this.onAddItem});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool _forExchange = false;
  XFile? _pickedImage;
  Uint8List? _pickedImageBytes;
  File? _pickedImageFile;
  String _selectedCategory = 'other';
  String _selectedCondition = 'used';

  static const List<String> categories = [
    'furniture',
    'electronics',
    'clothing',
    'books',
    'toys',
    'kitchen',
    'other',
  ];

  static const List<String> conditions = [
    'new',
    'good',
    'used',
  ];

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

  void _save() {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите название объявления')),
      );
      return;
    }

    final authState = context.read<AuthCubit>().state;
    final ownerId = authState.userEmail ?? 'guest_${DateTime.now().millisecondsSinceEpoch}';

    final item = Item(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      forExchange: _forExchange,
      ownerId: ownerId,
      owner: widget.ownerName,
      imagePath: kIsWeb ? null : _pickedImage?.path,
      imageBytes: kIsWeb ? _pickedImageBytes : null,
      imageUrl: _pickedImage == null 
          ? 'https://picsum.photos/seed/new/400/300' 
          : (kIsWeb ? null : _pickedImage?.path),
      category: _selectedCategory,
      condition: _selectedCondition,
    );

    // Интеграция с другими модулями
    context.read<ListingsCubit>().addListing(item);
    
    // Сохраняем состояние до обновления для проверки достижений
    final impactStateBefore = context.read<EcoImpactCubit>().state;
    context.read<EcoImpactCubit>().recalcImpactOnAdd(item);
    
    // Проверяем новые достижения после обновления
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final impactStateAfter = context.read<EcoImpactCubit>().state;
      final newAchievements = impactStateAfter.achievements
          .where((a) {
            final beforeAchievement = impactStateBefore.achievements
                .firstWhere((b) => b.id == a.id, orElse: () => a);
            return a.unlockedAt != null && beforeAchievement.unlockedAt == null;
          })
          .toList();
      
      if (newAchievements.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Text(newAchievements.first.icon, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Достижение разблокировано: ${newAchievements.first.title}'),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Посмотреть',
              textColor: Colors.white,
              onPressed: () {
                context.push('/impact/achievements');
              },
            ),
          ),
        );
      }
    });

    widget.onAddItem?.call(item);
    Navigator.pop(context, item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить объявление'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(
              'Создать объявление',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _titleCtrl,
              decoration: InputDecoration(
                labelText: 'Название объявления',
                hintText: 'Введите название',
                prefixIcon: const Icon(Icons.title),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descCtrl,
              decoration: InputDecoration(
                labelText: 'Описание',
                hintText: 'Опишите ваш товар подробно',
                prefixIcon: const Icon(Icons.description),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 4,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Text(
              'Фотография',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ImageHelper.buildImageWidget(
                  imageFile: _pickedImageFile,
                  imageBytes: _pickedImageBytes,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text('Выбрать фото'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Категория',
                prefixIcon: const Icon(Icons.category),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: categories.map((cat) {
                final labels = {
                  'furniture': 'Мебель',
                  'electronics': 'Электроника',
                  'clothing': 'Одежда',
                  'books': 'Книги',
                  'toys': 'Игрушки',
                  'kitchen': 'Кухня',
                  'other': 'Другое',
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
            DropdownButtonFormField<String>(
              value: _selectedCondition,
              decoration: InputDecoration(
                labelText: 'Состояние',
                prefixIcon: const Icon(Icons.check_circle_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: conditions.map((cond) {
                final labels = {
                  'new': 'Новое',
                  'good': 'Хорошее',
                  'used': 'Б/у',
                };
                return DropdownMenuItem(
                  value: cond,
                  child: Text(labels[cond] ?? cond),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedCondition = value);
              },
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.swap_horiz,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Возможен обмен',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Отметьте, если готовы обменять товар',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _forExchange,
                    onChanged: (v) => setState(() => _forExchange = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check_circle, size: 22),
                label: const Text(
                  'Создать объявление',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}