# Где посмотреть 5 сетевых запросов к Nominatim API

## 📍 Расположение кода

### 1. Определение запросов (Data Source)
**Файл:** `lib/data/datasources/remote/nominatim/nominatim_remote_data_source.dart`

Все 5 запросов определены в этом файле:
- **Строка 36-57**: `geocodeAddress` - прямой геокодинг (адрес → координаты)
- **Строка 81-104**: `searchAddresses` - поиск адресов по запросу
- **Строка 107-139**: `searchAddressesInCity` - поиск адресов в городе
- **Строка 59-78**: `searchAddressesByCountry` - поиск адресов в стране
- **Строка 141-178**: `searchObjectsByType` - поиск объектов по типу

### 2. Use Cases
**Папка:** `lib/domain/usecases/geocoding/`

- `geocode_address_usecase.dart`
- `search_addresses_usecase.dart`
- `search_addresses_in_city_usecase.dart`
- `search_addresses_by_country_usecase.dart`
- `search_objects_by_type_usecase.dart`

### 3. Cubit (управление состоянием)
**Файл:** `lib/features/listings/cubit/geocoding_cubit.dart`

Все методы доступны через `GeocodingCubit`:
- `searchAddresses(String query)` - поиск адресов
- `geocodeAddress(String address)` - прямой геокодинг
- `searchAddressesInCity(String query, String city)` - поиск в городе
- `searchAddressesByCountry(String query, String country)` - поиск в стране
- `searchObjectsByType(String objectType, String location)` - поиск объектов по типу

---

## 🖥️ Где используются в UI

### ✅ Запрос 1: `searchAddresses` - Поиск адресов
**Файл:** `lib/features/listings/screens/add_item_screen.dart`
**Строка:** 73

**Как протестировать:**
1. Откройте экран "Добавить объявление"
2. Начните вводить адрес в поле "Адрес (опционально)"
3. После ввода 3+ символов автоматически выполнится запрос
4. Результаты появятся в виде списка подсказок под полем

**В логах увидите:**
```
🌐 REQUEST[GET] => PATH: /search
   Query: {q: Москва, format: json, limit: 5}
✅ RESPONSE[200] => PATH: /search
```

---

### ✅ Запрос 2: `geocodeAddress` - Прямой геокодинг
**Файл:** `lib/features/listings/screens/add_item_screen.dart`
**Строка:** 82, 95

**Как протестировать:**
1. Откройте экран "Добавить объявление"
2. Введите адрес (например, "Москва, Красная площадь")
3. Нажмите "Сохранить"
4. При сохранении выполнится геокодинг адреса в координаты

**В логах увидите:**
```
🌐 REQUEST[GET] => PATH: /search
   Query: {q: Москва, Красная площадь, format: json, limit: 1}
✅ RESPONSE[200] => PATH: /search
```

---

### ✅ Запрос 3: `searchAddressesInCity` - Поиск в городе
**Файл:** `lib/features/listings/screens/add_item_screen.dart`
**Строка:** (чекбокс + поле города)

**Как протестировать:**
1. Откройте экран "Добавить объявление"
2. Включите чекбокс "Искать адреса в конкретном городе"
3. Введите запрос в поле адреса и название города
4. Результаты появятся в виде списка подсказок

**В логах увидите:**
```
🌐 REQUEST[GET] => PATH: /search
   Query: {q: улица, Москва, format: json, limit: 5, addressdetails: 1}
✅ RESPONSE[200] => PATH: /search
```

---

### ✅ Запрос 4: `searchAddressesByCountry` - Поиск в стране
**Файл:** `lib/features/listings/screens/listings_screen.dart`
**Строка:** Кнопка "Адреса" в навигации → Диалог "Поиск адресов в стране"

**Как протестировать:**
1. Откройте главный экран с объявлениями
2. Нажмите кнопку "Адреса" в навигационных кнопках
3. Введите запрос (например, "улица") и страну (например, "Россия")
4. Нажмите "Найти"
5. Результаты отобразятся в диалоге

**В логах увидите:**
```
🌐 Nominatim: Поиск адресов в стране "Россия" по запросу "улица"
🌐 REQUEST[GET] => PATH: /search
   Query: {q: улица, Россия, format: json, limit: 5, addressdetails: 1}
✅ RESPONSE[200] => PATH: /search
✅ Nominatim: Найдено X адресов в стране "Россия"
```

---

### ✅ Запрос 5: `searchObjectsByType` - Поиск объектов по типу
**Файл:** `lib/features/listings/screens/listings_screen.dart`
**Строка:** Кнопка "Пункты приема" в навигации → Диалог "Поиск пунктов приема"

**Как протестировать:**
1. Откройте главный экран с объявлениями
2. Нажмите кнопку "Пункты приема" в навигационных кнопках
3. Введите тип объекта на русском (например, "магазин", "переработка", "пункт приема") и город (например, "Москва")
4. Нажмите "Найти"
5. Результаты отобразятся в диалоге

**Примечание:** Можно вводить русские термины - они автоматически преобразуются в английские для API:
- "магазин" → "shop"
- "переработка" → "recycling"
- "пункт приема" → "recycling"
- "ремонт" → "repair"

**В логах увидите:**
```
🌐 Nominatim: Поиск объектов типа "магазин" (en: "shop") в "Москва"
🌐 REQUEST[GET] => PATH: /search
   Query: {q: shop Москва, format: json, limit: 10, addressdetails: 1}
✅ RESPONSE[200] => PATH: /search
✅ Nominatim: Найдено X объектов типа "магазин" в "Москва"
```

---

## 🔍 Как увидеть все запросы в логах

Все сетевые запросы логируются через `LoggingInterceptor`:
**Файл:** `lib/data/network/interceptors/logging_interceptor.dart`

В консоли вы увидите:
- `🌐 REQUEST[GET] => PATH: /search` - начало запроса
- `✅ RESPONSE[200] => PATH: /search` - успешный ответ
- `❌ ERROR[null] => PATH: /search` - ошибка запроса

---

## 📊 Сводная таблица

| № | Метод | Endpoint | Используется в UI | Где посмотреть |
|---|-------|----------|-------------------|----------------|
| 1 | `searchAddresses` | `/search` | ✅ Да | `add_item_screen.dart` - автодополнение |
| 2 | `geocodeAddress` | `/search` | ✅ Да | `add_item_screen.dart` - при сохранении |
| 3 | `searchAddressesInCity` | `/search` | ✅ Да | `add_item_screen.dart` - чекбокс + поле города |
| 4 | `searchAddressesByCountry` | `/search` | ✅ Да | `item_detail_screen.dart` - ExpansionTile |
| 5 | `searchObjectsByType` | `/search` | ✅ Да | `item_detail_screen.dart` - ExpansionTile |

---

## 🧪 Быстрый тест всех 5 запросов

### Через UI (все 5 запросов):
1. **Запрос 1**: Откройте "Добавить объявление" → введите "Москва" в поле адреса
2. **Запрос 2**: В том же экране → введите адрес → нажмите "Сохранить"
3. **Запрос 3**: В том же экране → включите чекбокс "Искать адреса в конкретном городе" → введите запрос и город
4. **Запрос 4**: Откройте любое объявление → раскройте "Поиск адресов в стране" → введите запрос и страну
5. **Запрос 5**: В том же экране → раскройте "Поиск объектов по типу" → введите тип объекта и местоположение

---

## 📝 Примечания

- Все запросы используют базовый URL: `https://nominatim.openstreetmap.org`
- Все запросы требуют заголовок `User-Agent` (уже настроен)
- Таймаут запросов: 30 секунд
- Все запросы логируются в консоль через `LoggingInterceptor`

