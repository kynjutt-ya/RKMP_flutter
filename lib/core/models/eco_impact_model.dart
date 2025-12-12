class EcoImpactModel {
  final int itemsDonated;
  final double kgSaved;
  final double co2Saved;
  final List<EcoAchievementModel> achievements;

  const EcoImpactModel({
    this.itemsDonated = 0,
    this.kgSaved = 0.0,
    this.co2Saved = 0.0,
    this.achievements = const [],
  });

  EcoImpactModel copyWith({
    int? itemsDonated,
    double? kgSaved,
    double? co2Saved,
    List<EcoAchievementModel>? achievements,
  }) {
    return EcoImpactModel(
      itemsDonated: itemsDonated ?? this.itemsDonated,
      kgSaved: kgSaved ?? this.kgSaved,
      co2Saved: co2Saved ?? this.co2Saved,
      achievements: achievements ?? this.achievements,
    );
  }
}

class EcoAchievementModel {
  final String id;
  final String title;
  final String description;
  final String icon;
  final DateTime? unlockedAt;
  final int targetValue;
  final int currentValue;

  const EcoAchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.unlockedAt,
    required this.targetValue,
    this.currentValue = 0,
  });

  EcoAchievementModel copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    DateTime? unlockedAt,
    int? targetValue,
    int? currentValue,
  }) {
    return EcoAchievementModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
    );
  }

  bool get isUnlocked => unlockedAt != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EcoAchievementModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

