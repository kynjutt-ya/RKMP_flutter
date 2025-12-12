class RecyclingPointModel {
  final String id;
  final String name;
  final String address;
  final String phone;
  final List<String> acceptedTypes;
  final double? latitude;
  final double? longitude;

  const RecyclingPointModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.acceptedTypes,
    this.latitude,
    this.longitude,
  });

  RecyclingPointModel copyWith({
    String? id,
    String? name,
    String? address,
    String? phone,
    List<String>? acceptedTypes,
    double? latitude,
    double? longitude,
  }) {
    return RecyclingPointModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      acceptedTypes: acceptedTypes ?? this.acceptedTypes,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecyclingPointModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

