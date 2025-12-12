import 'dart:typed_data';

class ListingDto {
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

  const ListingDto({
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

  ListingDto copyWith({
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
    return ListingDto(
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'forExchange': forExchange,
      'ownerId': ownerId,
      'owner': owner,
      'imageUrl': imageUrl,
      'imagePath': imagePath,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'condition': condition,
    };
  }

  factory ListingDto.fromJson(Map<String, dynamic> json) {
    return ListingDto(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      forExchange: json['forExchange'] as bool,
      ownerId: json['ownerId'] as String,
      owner: json['owner'] as String,
      imageUrl: json['imageUrl'] as String?,
      imagePath: json['imagePath'] as String?,
      category: json['category'] as String? ?? 'other',
      createdAt: DateTime.parse(json['createdAt'] as String),
      condition: json['condition'] as String? ?? 'used',
    );
  }
}

