/// DTO для ответа REST Countries API (упрощенная версия без json_serializable)
class CountryDto {
  final String name;
  final String? capital;
  final String? region;
  final String? subregion;
  final double? area;
  final int? population;

  CountryDto({
    required this.name,
    this.capital,
    this.region,
    this.subregion,
    this.area,
    this.population,
  });

  factory CountryDto.fromJson(Map<String, dynamic> json) {
    final nameData = json['name'];
    final name = nameData is Map ? (nameData['common'] as String? ?? '') : '';
    
    return CountryDto(
      name: name,
      capital: json['capital'] != null && (json['capital'] as List).isNotEmpty
          ? (json['capital'] as List).first as String?
          : null,
      region: json['region'] as String?,
      subregion: json['subregion'] as String?,
      area: json['area'] != null ? (json['area'] as num).toDouble() : null,
      population: json['population'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': {'common': name},
      'capital': capital != null ? [capital] : null,
      'region': region,
      'subregion': subregion,
      'area': area,
      'population': population,
    };
  }
}
