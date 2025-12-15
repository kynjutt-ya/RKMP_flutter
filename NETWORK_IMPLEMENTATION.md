# Реализация сетевого слоя

## Обзор

В приложении реализовано **5+ сетевых запросов** из **2 различных API**:

### 1. Nominatim API (OpenStreetMap) - 3 запроса
- **Прямой геокодинг**: преобразование адреса в координаты
- **Обратный геокодинг**: преобразование координат в адрес
- **Поиск адресов**: поиск адресов по запросу

### 2. Overpass API (OpenStreetMap) - 2 запроса
- **Поиск пунктов приема отходов**: поиск пунктов приема в радиусе от координат
- **Поиск сервисов ремонта**: поиск сервисов ремонта в радиусе от координат

## Структура файлов

```
lib/
├── data/
│   ├── network/
│   │   ├── dio_client.dart              # Базовый Dio клиент
│   │   ├── network_exceptions.dart       # Классы исключений
│   │   └── interceptors/
│   │       ├── logging_interceptor.dart  # Логирование запросов
│   │       └── error_interceptor.dart    # Обработка ошибок
│   └── datasources/
│       └── remote/
│           ├── nominatim/
│           │   ├── nominatim_dto.dart
│           │   ├── nominatim_remote_data_source.dart
│           │   └── nominatim_mapper.dart
│           └── overpass/
│               ├── overpass_dto.dart
│               ├── overpass_remote_data_source.dart
│               └── overpass_mapper.dart
└── domain/
    └── usecases/
        ├── geocoding/
        │   ├── geocode_address_usecase.dart
        │   ├── reverse_geocode_usecase.dart
        │   └── search_addresses_usecase.dart
        ├── eco_guide/
        │   └── find_recycling_points_nearby_usecase.dart
        └── repair/
            └── find_repair_services_nearby_usecase.dart
```

## Использование

### Пример 1: Прямой геокодинг (адрес -> координаты)

```dart
final geocodeUseCase = GeocodeAddressUseCase(nominatimDataSource);
final (lat, lon) = await geocodeUseCase('Москва, Красная площадь');
print('Координаты: $lat, $lon');
```

### Пример 2: Обратный геокодинг (координаты -> адрес)

```dart
final reverseGeocodeUseCase = ReverseGeocodeUseCase(nominatimDataSource);
final address = await reverseGeocodeUseCase(55.7558, 37.6173);
print('Адрес: $address');
```

### Пример 3: Поиск адресов

```dart
final searchUseCase = SearchAddressesUseCase(nominatimDataSource);
final addresses = await searchUseCase('Москва Ленина', limit: 5);
addresses.forEach((addr) => print(addr));
```

### Пример 4: Поиск пунктов приема отходов поблизости

```dart
final findPointsUseCase = FindRecyclingPointsNearbyUseCase(ecoGuideRepository);
final points = await findPointsUseCase(55.7558, 37.6173, 5.0); // радиус 5 км
points.forEach((point) => print('${point.name}: ${point.address}'));
```

### Пример 5: Поиск сервисов ремонта поблизости

```dart
final findServicesUseCase = FindRepairServicesNearbyUseCase(repairRepository);
final services = await findServicesUseCase(55.7558, 37.6173, 3.0); // радиус 3 км
services.forEach((service) => print('${service.name}: ${service.category}'));
```

## Интеграция в репозитории

Репозитории поддерживают комбинирование локальных и сетевых данных:
- Если сетевой запрос успешен - возвращаются данные с API
- Если сетевой запрос не удался - возвращаются локальные данные (fallback)

## Обработка ошибок

Все сетевые запросы обрабатывают следующие типы ошибок:
- `TimeoutException` - превышено время ожидания
- `BadRequestException` - некорректный запрос (400)
- `UnauthorizedException` - требуется авторизация (401)
- `NotFoundException` - ресурс не найден (404)
- `ServerException` - ошибка сервера (5xx)
- `NetworkException` - общие сетевые ошибки

