class RepairServiceDto {
  final String id;
  final String name;
  final String category;
  final String description;
  final double? priceFrom;
  final double rating;
  final String contact;

  const RepairServiceDto({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    this.priceFrom,
    this.rating = 0.0,
    required this.contact,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'priceFrom': priceFrom,
      'rating': rating,
      'contact': contact,
    };
  }

  factory RepairServiceDto.fromJson(Map<String, dynamic> json) {
    return RepairServiceDto(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      priceFrom: json['priceFrom'] as double?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      contact: json['contact'] as String,
    );
  }
}

