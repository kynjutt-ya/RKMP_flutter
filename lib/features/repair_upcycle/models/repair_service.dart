class RepairService {
  final String id;
  final String name;
  final String category; // furniture, electronics, textile
  final String description;
  final double? priceFrom;
  final double rating;
  final String contact;

  RepairService({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    this.priceFrom,
    this.rating = 0.0,
    required this.contact,
  });

  RepairService copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    double? priceFrom,
    double? rating,
    String? contact,
  }) {
    return RepairService(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      priceFrom: priceFrom ?? this.priceFrom,
      rating: rating ?? this.rating,
      contact: contact ?? this.contact,
    );
  }
}

