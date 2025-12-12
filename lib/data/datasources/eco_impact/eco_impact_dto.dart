
class EcoImpactDto {
  final int itemsDonated;
  final double kgSaved;
  final double co2Saved;
  final List<EcoAchievementDto> achievements;

  const EcoImpactDto({
    this.itemsDonated = 0,
    this.kgSaved = 0.0,
    this.co2Saved = 0.0,
    this.achievements = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'itemsDonated': itemsDonated,
      'kgSaved': kgSaved,
      'co2Saved': co2Saved,
      'achievements': achievements.map((a) => a.toJson()).toList(),
    };
  }

  factory EcoImpactDto.fromJson(Map<String, dynamic> json) {
    return EcoImpactDto(
      itemsDonated: json['itemsDonated'] as int? ?? 0,
      kgSaved: (json['kgSaved'] as num?)?.toDouble() ?? 0.0,
      co2Saved: (json['co2Saved'] as num?)?.toDouble() ?? 0.0,
      achievements: (json['achievements'] as List?)
          ?.map((a) => EcoAchievementDto.fromJson(a as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

/// Data Transfer Object для достижения
class EcoAchievementDto {
  final String id;
  final String title;
  final String description;
  final String icon;
  final DateTime? unlockedAt;
  final int targetValue;
  final int currentValue;

  const EcoAchievementDto({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.unlockedAt,
    required this.targetValue,
    this.currentValue = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'targetValue': targetValue,
      'currentValue': currentValue,
    };
  }

  factory EcoAchievementDto.fromJson(Map<String, dynamic> json) {
    return EcoAchievementDto(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
      targetValue: json['targetValue'] as int,
      currentValue: json['currentValue'] as int? ?? 0,
    );
  }
}

