// lib/features/eco_impact/cubit/eco_impact_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../listings/models/item.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final DateTime? unlockedAt;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.unlockedAt,
  });
}

class ImpactHistory {
  final DateTime date;
  final int itemsGiven;
  final double kgSaved;
  final double co2Saved;

  ImpactHistory({
    required this.date,
    required this.itemsGiven,
    required this.kgSaved,
    required this.co2Saved,
  });
}

class EcoImpactCubit extends Cubit<EcoImpactState> {
  EcoImpactCubit() : super(const EcoImpactState()) {
    _initializeAchievements();
  }

  void _initializeAchievements() {
    final achievements = [
      Achievement(
        id: 'first_gift',
        title: 'Первый шаг',
        description: 'Отдал первую вещь',
        icon: '🎁',
      ),
      Achievement(
        id: 'eco_warrior',
        title: 'Эко-воин',
        description: 'Отдал 10 вещей',
        icon: '🌱',
      ),
      Achievement(
        id: 'planet_saver',
        title: 'Спаситель планеты',
        description: 'Спас 50 кг от свалки',
        icon: '🌍',
      ),
    ];
    emit(state.copyWith(achievements: achievements));
  }

  void loadImpactData(String userId) {
    // В реальном приложении здесь будет загрузка с сервера
    // Пока используем текущее состояние
    emit(state);
  }

  void recalcImpactOnAdd(Item item) {
    // Примерная формула: каждая вещь = ~2 кг мусора, ~5 кг CO2
    const double kgPerItem = 2.0;
    const double co2PerItem = 5.0;

    final newTotalItems = state.totalItems + 1;
    final newTotalKgSaved = state.totalKgSaved + kgPerItem;
    final newTotalCO2Saved = state.totalCO2Saved + co2PerItem;

    // Добавляем запись в историю
    final newHistory = [
      ...state.history,
      ImpactHistory(
        date: DateTime.now(),
        itemsGiven: 1,
        kgSaved: kgPerItem,
        co2Saved: co2PerItem,
      ),
    ];

    emit(state.copyWith(
      totalItems: newTotalItems,
      totalKgSaved: newTotalKgSaved,
      totalCO2Saved: newTotalCO2Saved,
      history: newHistory,
    ));

    // Проверяем достижения
    _checkAchievements(newTotalItems, newTotalKgSaved);
  }

  void _checkAchievements(int totalItems, double totalKgSaved) {
    final updatedAchievements = state.achievements.map((achievement) {
      if (achievement.unlockedAt != null) return achievement;

      DateTime? unlockedAt;
      if (achievement.id == 'first_gift' && totalItems >= 1) {
        unlockedAt = DateTime.now();
      } else if (achievement.id == 'eco_warrior' && totalItems >= 10) {
        unlockedAt = DateTime.now();
      } else if (achievement.id == 'planet_saver' && totalKgSaved >= 50) {
        unlockedAt = DateTime.now();
      }

      return Achievement(
        id: achievement.id,
        title: achievement.title,
        description: achievement.description,
        icon: achievement.icon,
        unlockedAt: unlockedAt ?? achievement.unlockedAt,
      );
    }).toList();

    emit(state.copyWith(achievements: updatedAchievements));
  }

  void unlockAchievement(String achievementId) {
    final updatedAchievements = state.achievements.map((achievement) {
      if (achievement.id == achievementId && achievement.unlockedAt == null) {
        return Achievement(
          id: achievement.id,
          title: achievement.title,
          description: achievement.description,
          icon: achievement.icon,
          unlockedAt: DateTime.now(),
        );
      }
      return achievement;
    }).toList();

    emit(state.copyWith(achievements: updatedAchievements));
  }
}

class EcoImpactState {
  final int totalItems;
  final double totalKgSaved;
  final double totalCO2Saved;
  final List<Achievement> achievements;
  final List<ImpactHistory> history;

  const EcoImpactState({
    this.totalItems = 0,
    this.totalKgSaved = 0.0,
    this.totalCO2Saved = 0.0,
    this.achievements = const [],
    this.history = const [],
  });

  EcoImpactState copyWith({
    int? totalItems,
    double? totalKgSaved,
    double? totalCO2Saved,
    List<Achievement>? achievements,
    List<ImpactHistory>? history,
  }) {
    return EcoImpactState(
      totalItems: totalItems ?? this.totalItems,
      totalKgSaved: totalKgSaved ?? this.totalKgSaved,
      totalCO2Saved: totalCO2Saved ?? this.totalCO2Saved,
      achievements: achievements ?? this.achievements,
      history: history ?? this.history,
    );
  }
}
