class NominatimResponseDto {
  final double lat;
  final double lon;
  final String displayName;
  final AddressDto? address;

  NominatimResponseDto({
    required this.lat,
    required this.lon,
    required this.displayName,
    this.address,
  });

  factory NominatimResponseDto.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value is num) {
        return value.toDouble();
      } else if (value is String) {
        return double.parse(value);
      } else {
        throw FormatException('Не удалось преобразовать $value в double');
      }
    }

    return NominatimResponseDto(
      lat: parseDouble(json['lat']),
      lon: parseDouble(json['lon']),
      displayName: json['display_name'] as String? ?? '',
      address: json['address'] != null 
          ? AddressDto.fromJson(json['address'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lon': lon,
      'display_name': displayName,
      'address': address?.toJson(),
    };
  }
}

class AddressDto {
  final String? houseNumber;
  final String? road;
  final String? city;
  final String? state;
  final String? postcode;
  final String? country;

  AddressDto({
    this.houseNumber,
    this.road,
    this.city,
    this.state,
    this.postcode,
    this.country,
  });

  factory AddressDto.fromJson(Map<String, dynamic> json) {
    return AddressDto(
      houseNumber: json['house_number'] as String?,
      road: json['road'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      postcode: json['postcode'] as String?,
      country: json['country'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'house_number': houseNumber,
      'road': road,
      'city': city,
      'state': state,
      'postcode': postcode,
      'country': country,
    };
  }
}

