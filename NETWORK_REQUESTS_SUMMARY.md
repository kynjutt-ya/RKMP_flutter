# Сводка сетевых запросов

## Всего: 10 сетевых запросов из 2 API

### Nominatim API (OpenStreetMap) - 5 запросов:

1. **Прямой геокодинг** (`geocodeAddress`)
   - Функция: преобразование адреса в координаты
   - Использование: при создании объявления с адресом
   - Файл: `lib/data/datasources/remote/nominatim/nominatim_remote_data_source.dart:24`
   - Use Case: `GeocodeAddressUseCase`

2. **Поиск адресов в стране** (`searchAddressesByCountry`)
   - Функция: поиск адресов с фильтрацией по стране
   - Использование: уточненный поиск адресов в конкретной стране
   - Файл: `lib/data/datasources/remote/nominatim/nominatim_remote_data_source.dart:59`
   - Use Case: `SearchAddressesByCountryUseCase`
   - UI: `listings_screen.dart` - Кнопка "Адреса" в навигации → Диалог "Поиск адресов в стране"

3. **Поиск адресов** (`searchAddresses`)
   - Функция: поиск адресов по запросу
   - Использование: автодополнение при вводе адреса
   - Файл: `lib/data/datasources/remote/nominatim/nominatim_remote_data_source.dart:68`
   - Use Case: `SearchAddressesUseCase`

4. **Поиск адресов в городе** (`searchAddressesInCity`)
   - Функция: поиск адресов с фильтрацией по городу
   - Использование: уточненный поиск адресов в конкретном городе
   - Файл: `lib/data/datasources/remote/nominatim/nominatim_remote_data_source.dart:107`
   - Use Case: `SearchAddressesInCityUseCase`
   - UI: `add_item_screen.dart` - чекбокс "Искать адреса в конкретном городе" и поле для ввода города

5. **Поиск объектов по типу** (`searchObjectsByType`)
   - Функция: поиск объектов по типу (amenity, shop и т.д.)
   - Использование: поиск пунктов приема, магазинов и других объектов для экологии
   - Файл: `lib/data/datasources/remote/nominatim/nominatim_remote_data_source.dart:141`
   - Use Case: `SearchObjectsByTypeUseCase`
   - UI: `listings_screen.dart` - Кнопка "Пункты приема" в навигации → Диалог "Поиск пунктов приема"
   - Особенность: Поддерживает ввод русских терминов (автоматически преобразуются в английские для API)

### Wikipedia API (MediaWiki API) - 5 запросов:

1. **Поиск статей по запросу** (`searchArticles`)
   - Функция: поиск статей Wikipedia по текстовому запросу
   - Использование: поиск информации об экологии и переработке
   - Файл: `lib/data/datasources/remote/wikipedia/wikipedia_remote_data_source.dart:45`
   - Use Case: `SearchWikipediaArticlesUseCase`
   - UI: `eco_guide_screen.dart` - секция "1. Поиск статей по запросу"

2. **Получение содержимого статьи** (`getPageContent`)
   - Функция: получение полного содержимого статьи по названию
   - Использование: загрузка подробной информации об экологических темах
   - Файл: `lib/data/datasources/remote/wikipedia/wikipedia_remote_data_source.dart:70`
   - Use Case: `GetWikipediaPageContentUseCase`
   - UI: `eco_guide_screen.dart` - секция "2. Получение содержимого статьи"

3. **Получение статей из категории** (`getCategoryMembers`)
   - Функция: получение списка статей из определённой категории
   - Использование: получение всех статей по экологической тематике
   - Файл: `lib/data/datasources/remote/wikipedia/wikipedia_remote_data_source.dart:95`
   - Use Case: `GetWikipediaCategoryArticlesUseCase`
   - UI: `eco_guide_screen.dart` - секция "3. Получение статей из категории"

4. **Получение связанных статей** (`getPageLinks`)
   - Функция: получение списка статей, на которые ссылается указанная статья
   - Использование: навигация по связанным экологическим темам для более глубокого изучения
   - Файл: `lib/data/datasources/remote/wikipedia/wikipedia_remote_data_source.dart:144`
   - Use Case: `GetWikipediaPageLinksUseCase`
   - UI: `eco_guide_screen.dart` - секция "4. Получение связанных статей" + кнопка "🔗" на каждой статье в результатах

5. **Получение изображений статьи** (`getPageImages`)
   - Функция: получение списка изображений, используемых в статье
   - Использование: визуализация экологических тем
   - Файл: `lib/data/datasources/remote/wikipedia/wikipedia_remote_data_source.dart:186`
   - Use Case: `GetWikipediaPageImagesUseCase`
   - UI: `eco_guide_screen.dart` - секция "5. Получение изображений статьи"

## Интеграция в UI

### Nominatim API запросы используются в:
- `add_item_screen.dart`:
  - Запрос 1: `searchAddresses` - автодополнение при вводе адреса
  - Запрос 2: `geocodeAddress` - преобразование адреса в координаты при сохранении
  - Запрос 3: `searchAddressesInCity` - поиск адресов в городе (чекбокс + поле города)
- `listings_screen.dart`:
  - Запрос 4: `searchAddressesByCountry` - кнопка "Адреса" → диалог поиска адресов в стране
  - Запрос 5: `searchObjectsByType` - кнопка "Пункты приема" → диалог поиска объектов по типу

### Wikipedia API запросы используются в:
- `eco_guide_screen.dart` - все 5 запросов:
  - Запрос 1: `searchArticles` - поиск статей по запросу
  - Запрос 2: `getPageContent` - получение содержимого статьи
  - Запрос 3: `getCategoryMembers` - получение статей из категории
  - Запрос 4: `getPageLinks` - получение связанных статей (кнопка "🔗" на каждой статье)
  - Запрос 5: `getPageImages` - получение изображений статьи

## Структура файлов

```
lib/
├── data/
│   └── datasources/
│       └── remote/
│           ├── nominatim/          # 5 запросов Nominatim API
│           └── wikipedia/          # 5 запросов Wikipedia API
└── domain/
    └── usecases/
        ├── geocoding/              # 5 use cases для Nominatim
        └── wikipedia/              # 5 use cases для Wikipedia
```

