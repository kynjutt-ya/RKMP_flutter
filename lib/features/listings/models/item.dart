import 'dart:typed_data';

class Item {
  final String id;
  final String title;
  final String description;
  final bool forExchange;
  final String ownerId;
  final String owner; // имя владельца для отображения
  final String? imageUrl;
  final String? imagePath; // локальный путь для обратной совместимости
  final Uint8List? imageBytes; // bytes изображения для веб
  final String category; // furniture, electronics, clothing, etc.
  final DateTime createdAt;
  final String condition; // new, good, used

  Item({
    required this.id,
    required this.title,
    required this.description,
    required this.forExchange,
    required this.ownerId,
    required this.owner,
    this.imageUrl,
    this.imagePath,
    this.imageBytes,
    this.category = 'other',
    DateTime? createdAt,
    this.condition = 'used',
  }) : createdAt = createdAt ?? DateTime.now();

  Item copyWith({
    String? id,
    String? title,
    String? description,
    bool? forExchange,
    String? ownerId,
    String? owner,
    String? imageUrl,
    String? imagePath,
    Uint8List? imageBytes,
    String? category,
    DateTime? createdAt,
    String? condition,
  }) {
    return Item(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      forExchange: forExchange ?? this.forExchange,
      ownerId: ownerId ?? this.ownerId,
      owner: owner ?? this.owner,
      imageUrl: imageUrl ?? this.imageUrl,
      imagePath: imagePath ?? this.imagePath,
      imageBytes: imageBytes ?? this.imageBytes,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      condition: condition ?? this.condition,
    );
  }

  factory Item.empty() {
    return Item(
      id: '',
      title: '',
      description: '',
      forExchange: false,
      ownerId: '',
      owner: '',
      category: 'other',
      condition: 'used',
    );
  }
}