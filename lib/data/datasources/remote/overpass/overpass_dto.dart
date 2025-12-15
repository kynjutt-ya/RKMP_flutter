import 'package:json_annotation/json_annotation.dart';

part 'overpass_dto.g.dart';

/// DTO для ответа Overpass API
@JsonSerializable()
class OverpassResponseDto {
  final List<OverpassElementDto> elements;

  OverpassResponseDto({required this.elements});

  factory OverpassResponseDto.fromJson(Map<String, dynamic> json) =>
      _$OverpassResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OverpassResponseDtoToJson(this);
}

@JsonSerializable()
class OverpassElementDto {
  final String type;
  final int id;
  @JsonKey(name: 'lat', includeIfNull: false)
  final double? lat;
  @JsonKey(name: 'lon', includeIfNull: false)
  final double? lon;
  @JsonKey(name: 'center', includeIfNull: false)
  final OverpassCenterDto? center;
  final Map<String, dynamic>? tags;

  OverpassElementDto({
    required this.type,
    required this.id,
    this.lat,
    this.lon,
    this.center,
    this.tags,
  });

  /// Получить широту (из lat или center)
  double get latitude => lat ?? center?.lat ?? 0.0;

  /// Получить долготу (из lon или center)
  double get longitude => lon ?? center?.lon ?? 0.0;

  factory OverpassElementDto.fromJson(Map<String, dynamic> json) =>
      _$OverpassElementDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OverpassElementDtoToJson(this);
}

@JsonSerializable()
class OverpassCenterDto {
  final double lat;
  final double lon;

  OverpassCenterDto({
    required this.lat,
    required this.lon,
  });

  factory OverpassCenterDto.fromJson(Map<String, dynamic> json) =>
      _$OverpassCenterDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OverpassCenterDtoToJson(this);
}

