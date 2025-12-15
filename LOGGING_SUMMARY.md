# Сводка логирования сетевых запросов

## Всего: 10 сетевых запросов (5 Nominatim + 5 Wikipedia)

Все запросы логируются через **LoggingInterceptor** и имеют дополнительные **print** логи в data source методах.

---

## Nominatim API (5 запросов)

### 1. Прямой геокодинг (`geocodeAddress`)
**Логи:**
- `🌐 Nominatim: Прямой геокодинг адреса "{address}"` - начало запроса
- `🌐 REQUEST[GET] => PATH: /search` - через LoggingInterceptor
- `✅ RESPONSE[200] => PATH: /search` - через LoggingInterceptor
- `✅ Nominatim: Адрес геокодирован: {displayName} ({lat}, {lon})` - успешный результат
- `⚠️ Nominatim: Адрес не найден для "{address}"` - если адрес не найден
- `❌ Ошибка при геокодинге адреса: {error}` - при ошибке

**Файл:** `lib/data/datasources/remote/nominatim/nominatim_remote_data_source.dart:36`

---

### 2. Поиск адресов (`searchAddresses`)
**Логи:**
- `🌐 Nominatim: Поиск адресов по запросу "{query}"` - начало запроса
- `🌐 REQUEST[GET] => PATH: /search` - через LoggingInterceptor
- `✅ RESPONSE[200] => PATH: /search` - через LoggingInterceptor
- `✅ Nominatim: Найдено {count} адресов для "{query}"` - успешный результат
- `⚠️ Nominatim: Пустой ответ для "{query}"` - если результатов нет
- `❌ Ошибка при поиске адресов: {error}` - при ошибке

**Файл:** `lib/data/datasources/remote/nominatim/nominatim_remote_data_source.dart:95`

---

### 3. Поиск адресов в городе (`searchAddressesInCity`)
**Логи:**
- `🌐 Nominatim: Поиск адресов в городе "{city}" по запросу "{query}"` - начало запроса
- `🌐 REQUEST[GET] => PATH: /search` - через LoggingInterceptor
- `✅ RESPONSE[200] => PATH: /search` - через LoggingInterceptor
- `✅ Nominatim: Найдено {count} адресов в городе "{city}"` - успешный результат
- `⚠️ Nominatim: Пустой ответ для "{searchQuery}"` - если результатов нет
- `❌ Nominatim: Ошибка при поиске адресов в городе: {error}` - при ошибке

**Файл:** `lib/data/datasources/remote/nominatim/nominatim_remote_data_source.dart:121`

---

### 4. Поиск адресов в стране (`searchAddressesByCountry`)
**Логи:**
- `🌐 Nominatim: Поиск адресов в стране "{country}" по запросу "{query}"` - начало запроса
- `🌐 REQUEST[GET] => PATH: /search` - через LoggingInterceptor
- `✅ RESPONSE[200] => PATH: /search` - через LoggingInterceptor
- `✅ Nominatim: Найдено {count} адресов в стране "{country}"` - успешный результат
- `⚠️ Nominatim: Пустой ответ для "{searchQuery}"` - если результатов нет
- `❌ Nominatim: Ошибка при поиске адресов в стране: {error}` - при ошибке

**Файл:** `lib/data/datasources/remote/nominatim/nominatim_remote_data_source.dart:60`

---

### 5. Поиск объектов по типу (`searchObjectsByType`)
**Логи:**
- `🌐 Nominatim: Поиск объектов типа "{objectType}" в "{location}"` - начало запроса
- `🌐 REQUEST[GET] => PATH: /search` - через LoggingInterceptor
- `✅ RESPONSE[200] => PATH: /search` - через LoggingInterceptor
- `✅ Nominatim: Найдено {count} объектов типа "{objectType}" в "{location}"` - успешный результат
- `⚠️ Nominatim: Пустой ответ для "{searchQuery}"` - если результатов нет
- `❌ Nominatim: Ошибка при поиске объектов по типу: {error}` - при ошибке

**Файл:** `lib/data/datasources/remote/nominatim/nominatim_remote_data_source.dart:156`

---

## Wikipedia API (5 запросов)

### 6. Поиск статей по запросу (`searchArticles`)
**Логи:**
- `🌐 Wikipedia: Поиск статей по запросу "{query}"` - начало запроса
- `🌐 REQUEST[GET] => PATH: /w/api.php` - через LoggingInterceptor
- `✅ RESPONSE[200] => PATH: /w/api.php` - через LoggingInterceptor
- `✅ Wikipedia: Найдено {count} статей` - успешный результат
- `❌ Ошибка поиска статей Wikipedia: {error}` - при ошибке

**Файл:** `lib/data/datasources/remote/wikipedia/wikipedia_remote_data_source.dart:41`

---

### 7. Получение содержимого статьи (`getPageContent`)
**Логи:**
- `🌐 Wikipedia: Получение содержимого статьи "{title}"` - начало запроса
- `🌐 REQUEST[GET] => PATH: /w/api.php` - через LoggingInterceptor
- `✅ RESPONSE[200] => PATH: /w/api.php` - через LoggingInterceptor
- `❌ Ошибка получения содержимого Wikipedia: {error}` - при ошибке

**Файл:** `lib/data/datasources/remote/wikipedia/wikipedia_remote_data_source.dart:75`

---

### 8. Получение статей из категории (`getCategoryMembers`)
**Логи:**
- `🌐 Wikipedia: Получение статей из категории "{categoryTitle}"` - начало запроса
- `🌐 REQUEST[GET] => PATH: /w/api.php` - через LoggingInterceptor
- `✅ RESPONSE[200] => PATH: /w/api.php` - через LoggingInterceptor
- `✅ Wikipedia: Найдено {count} статей в категории` - успешный результат
- `❌ Ошибка получения категории Wikipedia: {error}` - при ошибке

**Файл:** `lib/data/datasources/remote/wikipedia/wikipedia_remote_data_source.dart:106`

---

### 9. Получение связанных статей (`getPageLinks`)
**Логи:**
- `🌐 Wikipedia: Получение связанных статей для "{title}"` - начало запроса
- `🌐 REQUEST[GET] => PATH: /w/api.php` - через LoggingInterceptor
- `✅ RESPONSE[200] => PATH: /w/api.php` - через LoggingInterceptor
- `✅ Wikipedia: Найдено {count} связанных статей` - успешный результат
- `❌ Ошибка получения связанных статей Wikipedia: {error}` - при ошибке

**Файл:** `lib/data/datasources/remote/wikipedia/wikipedia_remote_data_source.dart:145`

---

### 10. Получение изображений статьи (`getPageImages`)
**Логи:**
- `🌐 Wikipedia: Получение изображений для "{title}"` - начало первого запроса
- `🌐 REQUEST[GET] => PATH: /w/api.php` - через LoggingInterceptor (первый запрос)
- `✅ RESPONSE[200] => PATH: /w/api.php` - через LoggingInterceptor (первый запрос)
- `🌐 Wikipedia: Получение информации об изображениях для "{title}"` - начало второго запроса
- `🌐 REQUEST[GET] => PATH: /w/api.php` - через LoggingInterceptor (второй запрос)
- `✅ RESPONSE[200] => PATH: /w/api.php` - через LoggingInterceptor (второй запрос)
- `✅ Wikipedia: Найдено {count} изображений` - успешный результат
- `❌ Ошибка получения изображений Wikipedia: {error}` - при ошибке

**Файл:** `lib/data/datasources/remote/wikipedia/wikipedia_remote_data_source.dart:186`
**Примечание:** Этот метод делает 2 сетевых запроса (список изображений + детальная информация)

---

## Формат логов

### LoggingInterceptor (автоматически для всех запросов):
```
🌐 REQUEST[GET] => PATH: /search
   Query: {q: Москва, format: json, limit: 5}
✅ RESPONSE[200] => PATH: /search
   Data: [...]
❌ ERROR[404] => PATH: /search
   Message: Not Found
```

### Дополнительные логи в data source:
- `🌐` - начало запроса (с описанием)
- `✅` - успешный результат (с количеством/данными)
- `⚠️` - предупреждение (пустой ответ, не найдено)
- `❌` - ошибка

---

## Где настроено логирование

**LoggingInterceptor:** `lib/data/network/interceptors/logging_interceptor.dart`

**Подключение:**
- Nominatim API: `lib/main.dart:125` - `nominatimDio.interceptors.add(LoggingInterceptor());`
- Wikipedia API: `lib/main.dart:156, 170` - `wikipediaDio.interceptors.add(LoggingInterceptor());`

**Дополнительные логи:**
- Nominatim: в каждом методе `NominatimRemoteDataSourceImpl`
- Wikipedia: в каждом методе `WikipediaRemoteDataSourceImpl`

---

## Примеры логов в консоли

### Пример 1: Поиск адресов (Nominatim)
```
🌐 Nominatim: Поиск адресов по запросу "Москва"
🌐 REQUEST[GET] => PATH: /search
   Query: {q: Москва, format: json, limit: 5}
✅ RESPONSE[200] => PATH: /search
   Data: [...]
✅ Nominatim: Найдено 5 адресов для "Москва"
```

### Пример 2: Поиск статей Wikipedia
```
🌐 Wikipedia: Поиск статей по запросу "переработка"
🌐 REQUEST[GET] => PATH: /w/api.php
   Query: {action: query, list: search, srsearch: переработка, ...}
✅ RESPONSE[200] => PATH: /w/api.php
   Data: {...}
✅ Wikipedia: Найдено 5 статей
```

### Пример 3: Получение изображений (2 запроса)
```
🌐 Wikipedia: Получение изображений для "Экология"
🌐 REQUEST[GET] => PATH: /w/api.php
   Query: {action: query, prop: images|imageinfo, titles: Экология, ...}
✅ RESPONSE[200] => PATH: /w/api.php
🌐 Wikipedia: Получение информации об изображениях для "Экология"
🌐 REQUEST[GET] => PATH: /w/api.php
   Query: {action: query, titles: File:..., prop: imageinfo, ...}
✅ RESPONSE[200] => PATH: /w/api.php
✅ Wikipedia: Найдено 10 изображений
```

---

## Проверка логирования

Все 10 запросов имеют:
1. ✅ **LoggingInterceptor** - автоматическое логирование всех HTTP запросов
2. ✅ **Дополнительные print логи** - в методах data source для контекста
3. ✅ **Логи успешных результатов** - с количеством найденных элементов
4. ✅ **Логи ошибок** - с описанием проблемы

**Все запросы полностью логируются!** 🎉

