import 'dart:typed_data';

class ListingModel {
  final String id;
  final String title;
  final String description;
  final bool forExchange;
  final String ownerId;
  final String owner;
  final String? imageUrl;
  final String? imagePath;
  final Uint8List? imageBytes;
  final String category;
  final DateTime createdAt;
  final String condition;

  const ListingModel({
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
    required this.createdAt,
    this.condition = 'used',
  });

  ListingModel copyWith({
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
    return ListingModel(
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

  factory ListingModel.empty() {
    return ListingModel(
      id: '',
      title: '',
      description: '',
      forExchange: false,
      ownerId: '',
      owner: '',
      category: 'other',
      createdAt: DateTime.now(),
      condition: 'used',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListingModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

