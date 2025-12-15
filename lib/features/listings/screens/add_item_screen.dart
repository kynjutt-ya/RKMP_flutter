import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/models/listing_model.dart';
import '../../../shared/item_adapter.dart';
import '../models/item.dart';
import '../cubit/listings_cubit.dart';
import '../cubit/geocoding_cubit.dart';
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
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  bool _forExchange = false;
  bool _searchInCity = false;
  XFile? _pickedImage;
  Uint8List? _pickedImageBytes;
  File? _pickedImageFile;
  String _selectedCategory = 'other';
  String _selectedCondition = 'used';
  double? _listingLat;
  double? _listingLon;

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

  void _onAddressChanged(String value) {
    if (value.length >= 3) {
      if (_searchInCity && _cityCtrl.text.trim().isNotEmpty) {
        print('📍 Поиск в городе: "$value" в "${_cityCtrl.text.trim()}"');
        context.read<GeocodingCubit>().searchAddressesInCity(
              value,
              _cityCtrl.text.trim(),
            );
      } else {
        print('🔍 Обычный поиск: "$value"');
        context.read<GeocodingCubit>().searchAddresses(value);
      }
    } else {
      context.read<GeocodingCubit>().clearSuggestions();
    }
  }

  void _onCityChanged(String value) {
    if (_searchInCity && _addressCtrl.text.length >= 3 && value.trim().isNotEmpty) {
      context.read<GeocodingCubit>().searchAddressesInCity(
            _addressCtrl.text,
            value.trim(),
          );
    }
  }

  Future<void> _geocodeAddress(String address) async {
    if (address.trim().isEmpty) return;
    await context.read<GeocodingCubit>().geocodeAddress(address);
  }

  Future<void> _save() async {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите название объявления')),
      );
      return;
    }

    if (_addressCtrl.text.trim().isNotEmpty) {
      await _geocodeAddress(_addressCtrl.text.trim());
      await Future.delayed(const Duration(milliseconds: 500));
      final geocodingState = context.read<GeocodingCubit>().state;
      _listingLat = geocodingState.latitude;
      _listingLon = geocodingState.longitude;
      
      if (_listingLat != null && _listingLon != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Координаты получены: ${_listingLat!.toStringAsFixed(4)}, ${_listingLon!.toStringAsFixed(4)}')),
        );
      }
    }

    final authState = context.read<AuthCubit>().state;
    final ownerId = authState.userEmail ?? 'guest_${DateTime.now().millisecondsSinceEpoch}';

    final listing = ListingModel(
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
      createdAt: DateTime.now(),
    );

    context.read<ListingsCubit>().addListing(listing);

    final item = ItemAdapter.toItem(listing);
    final impactStateBefore = context.read<EcoImpactCubit>().state;
    context.read<EcoImpactCubit>().recalcImpactOnAdd(item);

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
            const SizedBox(height: 16),
            BlocBuilder<GeocodingCubit, GeocodingState>(
              builder: (context, geocodingState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _addressCtrl,
                      decoration: InputDecoration(
                        labelText: 'Адрес (опционально)',
                        hintText: 'Введите адрес для геокодинга',
                        prefixIcon: const Icon(Icons.location_on),
                        suffixIcon: geocodingState.isSearching
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: _onAddressChanged,
                      style: const TextStyle(fontSize: 16),
                    ),
                    if (geocodingState.addressSuggestions.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: geocodingState.addressSuggestions.map((address) {
                            return ListTile(
                              dense: true,
                              leading: const Icon(Icons.location_on, size: 20),
                              title: Text(address, style: const TextStyle(fontSize: 14)),
                              onTap: () {
                                _addressCtrl.text = address;
                                context.read<GeocodingCubit>().clearSuggestions();
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ] else if (geocodingState.isSearching) ...[
                      const SizedBox(height: 8),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 8),
                            Text('Поиск адресов...', style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Checkbox(
                          value: _searchInCity,
                          onChanged: (value) {
                            setState(() {
                              final wasEnabled = _searchInCity;
                              _searchInCity = value ?? false;
                              
                              if (!_searchInCity) {
                                _cityCtrl.clear();
                                context.read<GeocodingCubit>().clearSuggestions();
                                if (_addressCtrl.text.length >= 3) {
                                  context.read<GeocodingCubit>().searchAddresses(_addressCtrl.text);
                                }
                              } else {
                                print('✅ Поиск в городе включен');
                                if (_addressCtrl.text.length >= 3 && _cityCtrl.text.trim().isNotEmpty) {
                                  print('📍 Автоматический поиск: "${_addressCtrl.text}" в "${_cityCtrl.text.trim()}"');
                                  context.read<GeocodingCubit>().searchAddressesInCity(
                                        _addressCtrl.text,
                                        _cityCtrl.text.trim(),
                                      );
                                } else if (_addressCtrl.text.length >= 3) {
                                  print('⚠️ Город не указан, очищаем результаты');
                                  context.read<GeocodingCubit>().clearSuggestions();
                                }
                              }
                            });
                          },
                        ),
                        const Expanded(
                          child: Text('Искать адреса в конкретном городе'),
                        ),
                      ],
                    ),
                    if (_searchInCity) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Введите город, затем адрес для поиска в этом городе',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue.shade900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _cityCtrl,
                        decoration: InputDecoration(
                          labelText: 'Город',
                          hintText: 'Например: Москва',
                          prefixIcon: const Icon(Icons.location_city),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: _onCityChanged,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ],
                );
              },
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

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }
}