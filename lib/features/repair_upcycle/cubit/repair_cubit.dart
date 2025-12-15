// lib/features/repair_upcycle/cubit/repair_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/interfaces/repositories/repair_repository.dart';
import '../models/repair_service.dart';

class RepairRequest {
  final String id;
  final String userId;
  final String? itemId;
  final String category;
  final String description;
  final String? imageUrl;
  final double? proposedPrice;
  final DateTime createdAt;
  final String status; // pending, accepted, completed, rejected

  RepairRequest({
    required this.id,
    required this.userId,
    this.itemId,
    required this.category,
    required this.description,
    this.imageUrl,
    this.proposedPrice,
    DateTime? createdAt,
    this.status = 'pending',
  }) : createdAt = createdAt ?? DateTime.now();
}

class RepairCubit extends Cubit<RepairState> {
  final RepairRepository? repository;

  RepairCubit({
    this.repository,
  }) : super(const RepairState()) {
    _initializeServices();
  }

  void _initializeServices() {
    final allServices = [
      RepairService(
        id: '1',
        name: 'Мастер по мебели Иван',
        category: 'furniture',
        description: 'Ремонт и реставрация мебели. Опыт 10 лет.',
        priceFrom: 1000.0,
        rating: 4.8,
        contact: '+7 (495) 111-22-33',
      ),
      RepairService(
        id: '2',
        name: 'Электро-Сервис',
        category: 'electronics',
        description: 'Ремонт бытовой техники и электроники.',
        priceFrom: 500.0,
        rating: 4.5,
        contact: '+7 (495) 222-33-44',
      ),
      RepairService(
        id: '3',
        name: 'Ателье "Шитьё и ремонт"',
        category: 'textile',
        description: 'Ремонт одежды, перешивка, апсайклинг.',
        priceFrom: 300.0,
        rating: 4.9,
        contact: '+7 (495) 333-44-55',
      ),
    ];

    emit(state.copyWith(
      allServices: allServices,
      services: allServices,
      selectedCategory: null,
    ));
  }

  void setSelectedService(RepairService? service) {
    emit(state.copyWith(selectedService: service));
  }


  void loadServices({String? location, String? category}) {
    // Фильтрация по категории
    final filteredServices = category != null && category.isNotEmpty
        ? state.allServices.where((s) => s.category == category).toList()
        : state.allServices;

    emit(state.copyWith(
      services: filteredServices,
      selectedCategory: category,
    ));
  }

  void clearFilters() {
    emit(state.copyWith(
      services: state.allServices,
      selectedCategory: null,
    ));
  }

  void createRepairRequest({
    required String userId,
    String? itemId,
    required String category,
    required String description,
    String? imageUrl,
    double? proposedPrice,
  }) {
    final request = RepairRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      itemId: itemId,
      category: category,
      description: description,
      imageUrl: imageUrl,
      proposedPrice: proposedPrice,
    );

    final newRequests = [...state.requests, request];
    emit(state.copyWith(requests: newRequests));
  }

  void acceptRequest(String requestId) {
    final updatedRequests = state.requests.map((request) {
      if (request.id == requestId) {
        return RepairRequest(
          id: request.id,
          userId: request.userId,
          itemId: request.itemId,
          category: request.category,
          description: request.description,
          imageUrl: request.imageUrl,
          proposedPrice: request.proposedPrice,
          createdAt: request.createdAt,
          status: 'accepted',
        );
      }
      return request;
    }).toList();

    emit(state.copyWith(requests: updatedRequests));
  }

  void loadPortfolio(String serviceId) {
    // В реальном приложении здесь будет загрузка портфолио мастера
    // Пока просто обновляем selectedService
    final service = state.services.firstWhere(
      (s) => s.id == serviceId,
      orElse: () => state.services.first,
    );
    emit(state.copyWith(selectedService: service));
  }
}

class RepairState {
  final List<RepairService> allServices;
  final List<RepairService> services;
  final RepairService? selectedService;
  final List<RepairRequest> requests;
  final String? selectedCategory;
  final bool isLoading;
  final String? error;

  const RepairState({
    this.allServices = const [],
    this.services = const [],
    this.selectedService,
    this.requests = const [],
    this.selectedCategory,
    this.isLoading = false,
    this.error,
  });

  RepairState copyWith({
    List<RepairService>? allServices,
    List<RepairService>? services,
    RepairService? selectedService,
    List<RepairRequest>? requests,
    String? selectedCategory,
    bool? isLoading,
    String? error,
  }) {
    return RepairState(
      allServices: allServices ?? this.allServices,
      services: services ?? this.services,
      selectedService: selectedService ?? this.selectedService,
      requests: requests ?? this.requests,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
