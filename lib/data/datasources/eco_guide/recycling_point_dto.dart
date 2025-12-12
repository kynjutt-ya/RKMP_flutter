
class RecyclingPointDto {
  final String id;
  final String name;
  final String address;
  final String phone;
  final List<String> acceptedTypes;
  final double? latitude;
  final double? longitude;

  const RecyclingPointDto({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.acceptedTypes,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'acceptedTypes': acceptedTypes,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory RecyclingPointDto.fromJson(Map<String, dynamic> json) {
    return RecyclingPointDto(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      acceptedTypes: List<String>.from(json['acceptedTypes'] as List),
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
    );
  }
}

