# Wikipedia API - Использование в приложении

## Обзор

В приложении реализована интеграция с **Wikipedia API (MediaWiki API)** для получения информации об экологии, переработке отходов и других экологических темах. Всего реализовано **5 сетевых запросов**.

## API Endpoints

### Базовый URL
- **MediaWiki API**: `https://ru.wikipedia.org/w/api.php`
- **REST API**: `https://ru.wikipedia.org/api/rest_v1/`

## Реализованные запросы

### 1. Поиск статей по запросу (`searchArticles`)

**Функция**: Поиск статей Wikipedia по текстовому запросу.

**Endpoint**: `GET /w/api.php`
**Параметры**:
- `action=query`
- `list=search`
- `srsearch={query}` - поисковый запрос
- `srlimit={limit}` - количество результатов (по умолчанию 5)
- `format=json`
- `srnamespace=0` - только основные статьи

**Использование в коде**:
```dart
// Data Source
final results = await wikipediaDataSource.searchArticles('переработка отходов', limit: 5);

// Use Case
final tips = await searchWikipediaArticlesUseCase('переработка отходов', limit: 5);

// Cubit
context.read<EcoGuideCubit>().searchWikipediaArticles('переработка отходов', limit: 5);
```

**Где используется в UI**:
- `lib/features/eco_guide/screens/eco_guide_screen.dart` - секция "1. Поиск статей по запросу"
- Поле ввода для поискового запроса и кнопка "Найти"

---

### 2. Получение содержимого статьи (`getPageContent`)

**Функция**: Получение полного содержимого статьи Wikipedia по её названию.

**Endpoint**: `GET /w/api.php`
**Параметры**:
- `action=query`
- `prop=extracts|pageimages`
- `titles={title}` - название статьи
- `exintro=1` - только введение
- `explaintext=1` - текст без HTML
- `format=json`
- `pithumbsize=200` - размер миниатюры

**Использование в коде**:
```dart
// Data Source
final page = await wikipediaDataSource.getPageContent('Переработка отходов');

// Use Case
final tip = await getWikipediaPageContentUseCase('Переработка отходов');

// Cubit
context.read<EcoGuideCubit>().getWikipediaPageContent('Переработка отходов');
```

**Где используется в UI**:
- `lib/features/eco_guide/screens/eco_guide_screen.dart` - секция "2. Получение содержимого статьи"
- Поле ввода для названия статьи и кнопка "Загрузить"

---

### 3. Получение статей из категории (`getCategoryMembers`)

**Функция**: Получение списка статей, принадлежащих определённой категории Wikipedia.

**Endpoint**: `GET /w/api.php`
**Параметры**:
- `action=query`
- `list=categorymembers`
- `cmtitle=Категория:{category}` - название категории
- `cmlimit={limit}` - количество результатов (по умолчанию 10)
- `format=json`
- `cmnamespace=0` - только основные статьи

**Использование в коде**:
```dart
// Data Source
final members = await wikipediaDataSource.getCategoryMembers('Экология', limit: 10);

// Use Case
final tips = await getWikipediaCategoryArticlesUseCase('Экология', limit: 10);

// Cubit
context.read<EcoGuideCubit>().getWikipediaCategoryArticles('Экология', limit: 10);
```

**Где используется в UI**:
- `lib/features/eco_guide/screens/eco_guide_screen.dart` - секция "3. Получение статей из категории"
- Поле ввода для названия категории и кнопка "Загрузить"

---

### 4. Получение связанных статей (`getPageLinks`)

**Функция**: Получение списка статей, на которые ссылается указанная статья Wikipedia. Полезно для более глубокого изучения темы.

**Endpoint**: `GET /w/api.php`
**Параметры**:
- `action=query`
- `prop=links`
- `titles={title}` - название статьи
- `pllimit={limit}` - количество результатов (по умолчанию 10)
- `format=json`
- `plnamespace=0` - только основные статьи

**Использование в коде**:
```dart
// Data Source
final links = await wikipediaDataSource.getPageLinks('Экология', limit: 10);

// Use Case
final tips = await getWikipediaPageLinksUseCase('Экология', limit: 10);

// Cubit
context.read<EcoGuideCubit>().getWikipediaPageLinks('Экология', limit: 10);
```

**Где используется в UI**:
- `lib/features/eco_guide/screens/eco_guide_screen.dart` - секция "4. Получение связанных статей"
- Поле ввода для названия статьи и кнопка "Найти"
- Кнопка "🔗" на каждой статье в результатах для быстрого поиска связанных статей
- Подсказка: сначала найдите статью через "Поиск статей по запросу", затем используйте её название

---

### 5. Получение изображений статьи (`getPageImages`)

**Функция**: Получение списка изображений, используемых в указанной статье Wikipedia.

**Endpoint**: `GET /w/api.php`
**Параметры**:
- `action=query`
- `prop=images|imageinfo`
- `titles={title}` - название статьи
- `imlimit={limit}` - количество результатов (по умолчанию 10)
- `format=json`
- `iiprop=url|size` - свойства изображений

**Использование в коде**:
```dart
// Data Source
final images = await wikipediaDataSource.getPageImages('Переработка отходов', limit: 10);

// Use Case
final tips = await getWikipediaPageImagesUseCase('Переработка отходов', limit: 10);

// Cubit
context.read<EcoGuideCubit>().getWikipediaPageImages('Переработка отходов', limit: 10);
```

**Где используется в UI**:
- `lib/features/eco_guide/screens/eco_guide_screen.dart` - секция "5. Получение изображений статьи"
- Поле ввода для названия статьи и кнопка "Загрузить"

---

## Структура файлов

### Data Layer
- `lib/data/datasources/remote/wikipedia/wikipedia_dto.dart` - DTO для ответов API
- `lib/data/datasources/remote/wikipedia/wikipedia_remote_data_source.dart` - Реализация data source
- `lib/data/datasources/remote/wikipedia/wikipedia_mapper.dart` - Mapper для преобразования DTO в модели

### Domain Layer
- `lib/domain/usecases/wikipedia/search_wikipedia_articles_usecase.dart` - Use case для поиска статей
- `lib/domain/usecases/wikipedia/get_wikipedia_page_content_usecase.dart` - Use case для получения содержимого
- `lib/domain/usecases/wikipedia/get_wikipedia_category_articles_usecase.dart` - Use case для категорий
- `lib/domain/usecases/wikipedia/get_wikipedia_page_links_usecase.dart` - Use case для связанных статей
- `lib/domain/usecases/wikipedia/get_wikipedia_page_images_usecase.dart` - Use case для изображений

### Presentation Layer
- `lib/features/eco_guide/cubit/eco_guide_cubit.dart` - Cubit с методами для всех 5 запросов
- `lib/features/eco_guide/screens/eco_guide_screen.dart` - UI для демонстрации всех 5 запросов

### Repository
- `lib/domain/interfaces/repositories/eco_guide_repository.dart` - Интерфейс с методами Wikipedia API
- `lib/data/repositories/eco_guide_repository_impl.dart` - Реализация repository

## Инициализация

В `lib/main.dart`:
```dart
// Wikipedia API клиенты
final wikipediaDio = Dio(BaseOptions(
  baseUrl: 'https://ru.wikipedia.org',
  connectTimeout: const Duration(seconds: 30),
  receiveTimeout: const Duration(seconds: 30),
  headers: {
    'User-Agent': 'NeighborsApp/1.0 (Flutter App for local marketplace)',
    'Accept': 'application/json',
  },
));

final wikipediaClient = DioClient.fromDio(wikipediaDio);
final wikipediaRestClient = DioClient.fromDio(wikipediaRestDio);

final wikipediaDataSource = WikipediaRemoteDataSourceImpl(
  dioClient: wikipediaClient,
  restClient: wikipediaRestClient,
);

// Use cases
final searchWikipediaArticlesUseCase = SearchWikipediaArticlesUseCase(ecoGuideRepository);
// ... остальные use cases

// Cubit
final ecoGuideCubit = EcoGuideCubit(
  // ... другие параметры
  searchWikipediaArticlesUseCase: searchWikipediaArticlesUseCase,
  // ... остальные use cases
);
```

## Примеры использования

### Пример 1: Поиск статей об экологии
```dart
context.read<EcoGuideCubit>().searchWikipediaArticles('экология', limit: 5);
```

### Пример 2: Получение статьи о переработке
```dart
context.read<EcoGuideCubit>().getWikipediaPageContent('Переработка отходов');
```

### Пример 3: Статьи из категории "Экология"
```dart
context.read<EcoGuideCubit>().getWikipediaCategoryArticles('Экология', limit: 10);
```

### Пример 4: Связанные статьи
```dart
context.read<EcoGuideCubit>().getWikipediaPageLinks('Экология', limit: 10);
```

### Пример 5: Изображения статьи
```dart
context.read<EcoGuideCubit>().getWikipediaPageImages('Переработка отходов', limit: 10);
```

## Особенности реализации

1. **User-Agent заголовок**: Обязателен для всех запросов к Wikipedia API
2. **Обработка ошибок**: Все методы обрабатывают NetworkException и возвращают пустые списки или выбрасывают исключения
3. **Преобразование данных**: Wikipedia DTO преобразуются в EcoTipModel через WikipediaMapper
4. **Получение изображений**: Для получения изображений выполняется два запроса - сначала список изображений, затем детальная информация
5. **Фильтрация HTML**: HTML теги удаляются из текста статей

## Тестирование

Все 5 запросов можно протестировать в UI:
1. Откройте экран "Эко-гид / Утилизация"
2. Используйте соответствующие секции для каждого запроса
3. Результаты отображаются в нижней части экрана

