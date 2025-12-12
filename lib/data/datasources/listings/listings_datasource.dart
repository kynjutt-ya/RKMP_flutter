import 'package:sqflite/sqflite.dart';
import '../../database/database_helper.dart';
import 'listing_dto.dart';

abstract class ListingsDataSource {
  Future<List<ListingDto>> getAllListings();
  Future<ListingDto?> getListingById(String id);
  Future<ListingDto> addListing(ListingDto listing);
  Future<void> deleteListing(String id);
  Future<List<ListingDto>> getMyListings(String ownerId);
}

class SQLiteListingsDataSource implements ListingsDataSource {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  Future<List<ListingDto>> getAllListings() async {
    try {
      print('🔄 Начало загрузки объявлений из БД...');
      final db = await _dbHelper.database;
      print('✅ БД получена, выполняю запрос...');
      final maps = await db.query(
        'listings',
        orderBy: 'createdAt DESC',
      );
      print('📖 Загружено объявлений из БД: ${maps.length}');
      if (maps.isEmpty) {
        print('⚠️ БД пуста, проверяю наличие таблицы...');
        // Проверяем, существует ли таблица
        final tables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='listings'"
        );
        print('📋 Найдено таблиц listings: ${tables.length}');
      }
      final listings = List.generate(maps.length, (i) => _mapToListingDto(maps[i]));
      for (var listing in listings) {
        print('  - ${listing.id}: ${listing.title}');
      }
      return listings;
    } catch (e, stackTrace) {
      print('❌ Ошибка при загрузке объявлений: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  @override
  Future<ListingDto?> getListingById(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'listings',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return _mapToListingDto(maps.first);
  }

  @override
  Future<ListingDto> addListing(ListingDto listing) async {
    final db = await _dbHelper.database;
    final map = _listingDtoToMap(listing);
    final result = await db.insert(
      'listings',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('✅ Объявление сохранено в БД: id=${listing.id}, title=${listing.title}, result=$result');
    return listing;
  }

  @override
  Future<void> deleteListing(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'listings',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<ListingDto>> getMyListings(String ownerId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'listings',
        where: 'ownerId = ?',
        whereArgs: [ownerId],
        orderBy: 'createdAt DESC',
      );
      return List.generate(maps.length, (i) => _mapToListingDto(maps[i]));
    } catch (e) {
      print('❌ Ошибка при получении моих объявлений: $e');
      return [];
    }
  }

  Map<String, dynamic> _listingDtoToMap(ListingDto dto) {
    return {
      'id': dto.id,
      'title': dto.title,
      'description': dto.description,
      'forExchange': dto.forExchange ? 1 : 0,
      'ownerId': dto.ownerId,
      'owner': dto.owner,
      'imageUrl': dto.imageUrl,
      'imagePath': dto.imagePath,
      'category': dto.category,
      'createdAt': dto.createdAt.toIso8601String(),
      'condition': dto.condition,
    };
  }

  ListingDto _mapToListingDto(Map<String, dynamic> map) {
    return ListingDto(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      forExchange: (map['forExchange'] as int) == 1,
      ownerId: map['ownerId'] as String,
      owner: map['owner'] as String,
      imageUrl: map['imageUrl'] as String?,
      imagePath: map['imagePath'] as String?,
      category: map['category'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      condition: map['condition'] as String,
    );
  }
}

// Старая реализация для обратной совместимости (можно удалить после тестирования)
class InMemoryListingsDataSource implements ListingsDataSource {
  final List<ListingDto> _listings = [];

  InMemoryListingsDataSource() {
    _initializeDemoData();
  }

  void _initializeDemoData() {
    _listings.addAll([
      ListingDto(
        id: '1',
        title: 'Настольная лампа',
        description: 'Современная настольная лампа в хорошем состоянии',
        forExchange: false,
        ownerId: 'alexey@example.com',
        owner: 'Алексей',
        imageUrl: 'https://cdn1.ozone.ru/s3/multimedia-c/6397661772.jpg',
        category: 'electronics',
        condition: 'good',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      ListingDto(
        id: '2',
        title: 'Кресло',
        description: 'Мягкое офисное кресло, возможен обмен',
        forExchange: true,
        ownerId: 'irina@example.com',
        owner: 'Ирина',
        imageUrl: 'https://avatars.mds.yandex.net/get-mpic/12366926/2a00000193f6a60316c7671dbd7ce04821a8/orig',
        category: 'furniture',
        condition: 'used',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      ListingDto(
        id: '3',
        title: 'Полка для книг',
        description: 'Деревянная полка, отличное состояние',
        forExchange: false,
        ownerId: 'mikhail@example.com',
        owner: 'Михаил',
        imageUrl: 'https://avatars.mds.yandex.net/i?id=86d5887e8ef7cbf34155b28dc5aac7b5_l-4483413-images-thumbs&n=13',
        category: 'furniture',
        condition: 'good',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      ListingDto(
        id: '4',
        title: 'Детские книги',
        description: 'Коллекция детских книг, хорошее состояние',
        forExchange: true,
        ownerId: 'maria@example.com',
        owner: 'Мария',
        imageUrl: 'https://picsum.photos/seed/books/400/300',
        category: 'books',
        condition: 'good',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      ListingDto(
        id: '5',
        title: 'Куртка зимняя',
        description: 'Тёплая зимняя куртка, размер M',
        forExchange: false,
        ownerId: 'dmitry@example.com',
        owner: 'Дмитрий',
        imageUrl: 'https://picsum.photos/seed/clothing/400/300',
        category: 'clothing',
        condition: 'good',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
      ListingDto(
        id: '6',
        title: 'Набор игрушек',
        description: 'Развивающие игрушки для детей',
        forExchange: true,
        ownerId: 'olga@example.com',
        owner: 'Ольга',
        imageUrl: 'https://picsum.photos/seed/toys/400/300',
        category: 'toys',
        condition: 'used',
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
      ),
      ListingDto(
        id: '7',
        title: 'Кофемашина',
        description: 'Кофемашина в рабочем состоянии',
        forExchange: false,
        ownerId: 'sergey@example.com',
        owner: 'Сергей',
        imageUrl: 'https://picsum.photos/seed/coffee/400/300',
        category: 'kitchen',
        condition: 'used',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
    ]);
  }

  @override
  Future<List<ListingDto>> getAllListings() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.from(_listings);
  }

  @override
  Future<ListingDto?> getListingById(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    try {
      return _listings.firstWhere((listing) => listing.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ListingDto> addListing(ListingDto listing) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _listings.add(listing);
    return listing;
  }

  @override
  Future<void> deleteListing(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    _listings.removeWhere((listing) => listing.id == id);
  }

  @override
  Future<List<ListingDto>> getMyListings(String ownerId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _listings.where((listing) => listing.ownerId == ownerId).toList();
  }
}

