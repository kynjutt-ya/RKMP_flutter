class RepairServiceModel {
  final String id;
  final String name;
  final String category;
  final String description;
  final double? priceFrom;
  final double rating;
  final String contact;

  const RepairServiceModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    this.priceFrom,
    this.rating = 0.0,
    required this.contact,
  });

  RepairServiceModel copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    double? priceFrom,
    double? rating,
    String? contact,
  }) {
    return RepairServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      priceFrom: priceFrom ?? this.priceFrom,
      rating: rating ?? this.rating,
      contact: contact ?? this.contact,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepairServiceModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

