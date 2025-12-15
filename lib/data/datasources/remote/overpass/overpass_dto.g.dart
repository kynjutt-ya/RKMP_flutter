// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overpass_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OverpassResponseDto _$OverpassResponseDtoFromJson(Map<String, dynamic> json) =>
    OverpassResponseDto(
      elements: (json['elements'] as List<dynamic>)
          .map((e) => OverpassElementDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OverpassResponseDtoToJson(
  OverpassResponseDto instance,
) => <String, dynamic>{'elements': instance.elements};

OverpassElementDto _$OverpassElementDtoFromJson(Map<String, dynamic> json) =>
    OverpassElementDto(
      type: json['type'] as String,
      id: (json['id'] as num).toInt(),
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
      center: json['center'] == null
          ? null
          : OverpassCenterDto.fromJson(json['center'] as Map<String, dynamic>),
      tags: json['tags'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$OverpassElementDtoToJson(OverpassElementDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
      'lat': ?instance.lat,
      'lon': ?instance.lon,
      'center': ?instance.center,
      'tags': instance.tags,
    };

OverpassCenterDto _$OverpassCenterDtoFromJson(Map<String, dynamic> json) =>
    OverpassCenterDto(
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
    );

Map<String, dynamic> _$OverpassCenterDtoToJson(OverpassCenterDto instance) =>
    <String, dynamic>{'lat': instance.lat, 'lon': instance.lon};
