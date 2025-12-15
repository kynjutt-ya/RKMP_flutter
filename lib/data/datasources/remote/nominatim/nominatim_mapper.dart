import 'nominatim_dto.dart';

class NominatimMapper {
  static (double lat, double lon) toCoordinates(NominatimResponseDto dto) {
    return (dto.lat, dto.lon);
  }

  static String toAddressString(NominatimResponseDto dto) {
    return dto.displayName;
  }

  static String toFormattedAddress(NominatimResponseDto dto) {
    final address = dto.address;
    if (address == null) {
      return dto.displayName;
    }

    final parts = <String>[];
    if (address.houseNumber != null && address.road != null) {
      parts.add('${address.road}, ${address.houseNumber}');
    } else if (address.road != null) {
      parts.add(address.road!);
    }
    if (address.city != null) {
      parts.add(address.city!);
    }
    if (address.postcode != null) {
      parts.add(address.postcode!);
    }

    return parts.isNotEmpty ? parts.join(', ') : dto.displayName;
  }
}

