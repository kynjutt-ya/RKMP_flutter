import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/geocoding/geocode_address_usecase.dart';
import '../../../domain/usecases/geocoding/search_addresses_usecase.dart';
import '../../../domain/usecases/geocoding/search_addresses_in_city_usecase.dart';
import '../../../domain/usecases/geocoding/search_addresses_by_country_usecase.dart';
import '../../../domain/usecases/geocoding/search_objects_by_type_usecase.dart';

class GeocodingCubit extends Cubit<GeocodingState> {
  final GeocodeAddressUseCase geocodeAddressUseCase;
  final SearchAddressesUseCase searchAddressesUseCase;
  final SearchAddressesInCityUseCase searchAddressesInCityUseCase;
  final SearchAddressesByCountryUseCase searchAddressesByCountryUseCase;
  final SearchObjectsByTypeUseCase searchObjectsByTypeUseCase;

  GeocodingCubit({
    required this.geocodeAddressUseCase,
    required this.searchAddressesUseCase,
    required this.searchAddressesInCityUseCase,
    required this.searchAddressesByCountryUseCase,
    required this.searchObjectsByTypeUseCase,
  }) : super(const GeocodingState());

  Future<void> searchAddresses(String query) async {
    if (query.trim().isEmpty || query.length < 3) {
      emit(state.copyWith(addressSuggestions: []));
      return;
    }

    emit(state.copyWith(isSearching: true));
    try {
      final addresses = await searchAddressesUseCase(query, limit: 5);
      print('🔍 Найдено адресов: ${addresses.length}');
      for (var i = 0; i < addresses.length; i++) {
        print('  ${i + 1}. ${addresses[i]}');
      }
      final newState = state.copyWith(
        addressSuggestions: addresses,
        isSearching: false,
        clearError: true,
      );
      emit(newState);
      print('✅ Состояние обновлено, адресов в состоянии: ${newState.addressSuggestions.length}');
    } catch (e) {
      print('❌ Ошибка поиска адресов: $e');
      emit(state.copyWith(
        addressSuggestions: [],
        isSearching: false,
        error: 'Ошибка поиска адресов: $e',
      ));
    }
  }

  Future<void> geocodeAddress(String address) async {
    if (address.trim().isEmpty) return;

    emit(state.copyWith(isGeocoding: true));
    try {
      final (lat, lon) = await geocodeAddressUseCase(address);
      emit(state.copyWith(
        latitude: lat,
        longitude: lon,
        isGeocoding: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isGeocoding: false,
        error: 'Ошибка геокодинга: $e',
      ));
    }
  }

  Future<void> searchAddressesByCountry(String query, String country) async {
    if (query.trim().isEmpty || country.trim().isEmpty) {
      emit(state.copyWith(addressSuggestions: []));
      return;
    }

    print('🔍 Поиск адресов в стране: "$query" в "$country"');
    emit(state.copyWith(isSearching: true));
    try {
      final addresses = await searchAddressesByCountryUseCase(query, country, limit: 5);
      print('🔍 Найдено адресов в стране: ${addresses.length}');
      final newState = state.copyWith(
        addressSuggestions: addresses,
        isSearching: false,
        clearError: true,
      );
      emit(newState);
    } catch (e) {
      print('❌ Ошибка поиска адресов в стране: $e');
      emit(state.copyWith(
        addressSuggestions: [],
        isSearching: false,
        error: 'Ошибка поиска адресов в стране: $e',
      ));
    }
  }

  Future<void> searchAddressesInCity(String query, String city) async {
    if (query.trim().isEmpty || city.trim().isEmpty) {
      print('⚠️ Поиск в городе: пустой запрос или город');
      emit(state.copyWith(addressSuggestions: []));
      return;
    }

    print('🔍 Поиск адресов в городе: "$query" в "$city"');
    emit(state.copyWith(isSearching: true));
    try {
      final addresses = await searchAddressesInCityUseCase(query, city, limit: 5);
      print('🔍 Найдено адресов в городе: ${addresses.length}');
      for (var i = 0; i < addresses.length; i++) {
        print('  ${i + 1}. ${addresses[i]}');
      }
      final newState = state.copyWith(
        addressSuggestions: addresses,
        isSearching: false,
        clearError: true,
      );
      emit(newState);
      print('✅ Состояние обновлено, адресов в состоянии: ${newState.addressSuggestions.length}');
    } catch (e) {
      print('❌ Ошибка поиска адресов в городе: $e');
      emit(state.copyWith(
        addressSuggestions: [],
        isSearching: false,
        error: 'Ошибка поиска адресов в городе: $e',
      ));
    }
  }

  Future<void> searchObjectsByType(String objectType, String location) async {
    if (objectType.trim().isEmpty || location.trim().isEmpty) {
      emit(state.copyWith(addressSuggestions: []));
      return;
    }

    print('🔍 Поиск объектов по типу: "$objectType" в "$location"');
    emit(state.copyWith(isSearching: true));
    try {
      final addresses = await searchObjectsByTypeUseCase(objectType, location, limit: 10);
      print('🔍 Найдено объектов: ${addresses.length}');
      final newState = state.copyWith(
        addressSuggestions: addresses,
        isSearching: false,
        clearError: true,
      );
      emit(newState);
    } catch (e) {
      print('❌ Ошибка поиска объектов по типу: $e');
      emit(state.copyWith(
        addressSuggestions: [],
        isSearching: false,
        error: 'Ошибка поиска объектов по типу: $e',
      ));
    }
  }

  void clearSuggestions() {
    emit(state.copyWith(addressSuggestions: []));
  }
}

class GeocodingState {
  final List<String> addressSuggestions;
  final bool isSearching;
  final bool isGeocoding;
  final double? latitude;
  final double? longitude;
  final String? error;

  const GeocodingState({
    this.addressSuggestions = const [],
    this.isSearching = false,
    this.isGeocoding = false,
    this.latitude,
    this.longitude,
    this.error,
  });

  GeocodingState copyWith({
    List<String>? addressSuggestions,
    bool? isSearching,
    bool? isGeocoding,
    double? latitude,
    double? longitude,
    String? error,
    bool clearError = false,
  }) {
    final newState = GeocodingState(
      addressSuggestions: addressSuggestions ?? this.addressSuggestions,
      isSearching: isSearching ?? this.isSearching,
      isGeocoding: isGeocoding ?? this.isGeocoding,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      error: clearError ? null : (error ?? this.error),
    );
    print('🔄 copyWith: адресов было ${this.addressSuggestions.length}, стало ${newState.addressSuggestions.length}');
    return newState;
  }
}

