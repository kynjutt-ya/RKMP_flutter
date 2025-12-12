import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    
    _database = await _initDB('neighbors_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);

      final db = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          print('🔨 onCreate вызван - создаю таблицы...');
          await _createDB(db, version);
        },
      );
      print('✅ База данных открыта успешно');
      
      return db;
    } catch (e, stackTrace) {
      print('❌ Ошибка при открытии БД: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> _createDB(Database db, int version) async {
    print('🔨 Создание таблиц в БД...');
    try {
      await db.execute('''
        CREATE TABLE listings (
          id TEXT PRIMARY KEY,
          title TEXT NOT NULL,
          description TEXT NOT NULL,
          forExchange INTEGER NOT NULL,
          ownerId TEXT NOT NULL,
          owner TEXT NOT NULL,
          imageUrl TEXT,
          imagePath TEXT,
          category TEXT NOT NULL,
          createdAt TEXT NOT NULL,
          condition TEXT NOT NULL
        )
      ''');
      print('✅ Таблица listings создана');

      await db.execute('''
        CREATE TABLE support_tickets (
          id TEXT PRIMARY KEY,
          userId TEXT NOT NULL,
          itemId TEXT,
          category TEXT NOT NULL,
          message TEXT NOT NULL,
          createdAt TEXT NOT NULL,
          status TEXT NOT NULL
        )
      ''');

    await db.execute('''
      CREATE TABLE repair_services (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        description TEXT NOT NULL,
        priceFrom REAL NOT NULL,
        rating REAL NOT NULL,
        contact TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE eco_tips (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        imageUrl TEXT,
        createdAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE recycling_points (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        address TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        acceptedTypes TEXT NOT NULL,
        phone TEXT,
        website TEXT
      )
    ''');

      await _insertInitialData(db);
      print('✅ Начальные данные вставлены');
    } catch (e, stackTrace) {
      print('❌ Ошибка при создании БД: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> _insertInitialData(Database db) async {
    print('📝 Начало вставки начальных данных...');
    final now = DateTime.now();
    
    try {
      final result1 = await db.insert('listings', {
        'id': '1',
        'title': 'Настольная лампа',
        'description': 'Современная настольная лампа в хорошем состоянии',
        'forExchange': 0,
        'ownerId': 'alexey@example.com',
        'owner': 'Алексей',
        'imageUrl': 'https://cdn1.ozone.ru/s3/multimedia-c/6397661772.jpg',
        'category': 'electronics',
        'createdAt': now.subtract(const Duration(days: 2)).toIso8601String(),
        'condition': 'good',
      });
      print('✅ Вставлено объявление 1: result=$result1');

      final result2 = await db.insert('listings', {
        'id': '2',
        'title': 'Кресло',
        'description': 'Мягкое офисное кресло, возможен обмен',
        'forExchange': 1,
        'ownerId': 'irina@example.com',
        'owner': 'Ирина',
        'imageUrl': 'https://avatars.mds.yandex.net/get-mpic/12366926/2a00000193f6a60316c7671dbd7ce04821a8/orig',
        'category': 'furniture',
        'createdAt': now.subtract(const Duration(days: 5)).toIso8601String(),
        'condition': 'used',
      });
      print('✅ Вставлено объявление 2: result=$result2');
      
      // Проверяем, что данные действительно вставлены
      final count = await db.rawQuery('SELECT COUNT(*) as count FROM listings');
      final listingsCount = count.first['count'] as int;
      print('📊 Всего объявлений в БД после вставки: $listingsCount');
    } catch (e, stackTrace) {
      print('❌ Ошибка при вставке начальных данных: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }

    await db.insert('repair_services', {
      'id': '1',
      'name': 'Мастер по мебели Иван',
      'category': 'furniture',
      'description': 'Ремонт и реставрация мебели. Опыт 10 лет.',
      'priceFrom': 1000.0,
      'rating': 4.8,
      'contact': '+7 (495) 111-22-33',
    });

    await db.insert('repair_services', {
      'id': '2',
      'name': 'Электро-Сервис',
      'category': 'electronics',
      'description': 'Ремонт бытовой техники и электроники.',
      'priceFrom': 500.0,
      'rating': 4.5,
      'contact': '+7 (495) 222-33-44',
    });

    await db.insert('eco_tips', {
      'id': '1',
      'title': 'Сортируйте отходы',
      'content': 'Разделяйте мусор на категории: бумага, пластик, стекло, металл.',
      'createdAt': now.subtract(const Duration(days: 10)).toIso8601String(),
    });

    await db.insert('eco_tips', {
      'id': '2',
      'title': 'Используйте многоразовые сумки',
      'content': 'Откажитесь от пластиковых пакетов в пользу тканевых сумок.',
      'createdAt': now.subtract(const Duration(days: 5)).toIso8601String(),
    });

    await db.insert('recycling_points', {
      'id': '1',
      'name': 'Эко-Пункт на Ленина',
      'address': 'ул. Ленина, д. 10',
      'latitude': 55.7558,
      'longitude': 37.6173,
      'acceptedTypes': 'paper,plastic,glass',
      'phone': '+7 (495) 123-45-67',
      'website': null,
    });

    await db.insert('recycling_points', {
      'id': '2',
      'name': 'Приём электроники',
      'address': 'ул. Мира, д. 25',
      'latitude': 55.7512,
      'longitude': 37.6184,
      'acceptedTypes': 'electronics,batteries',
      'phone': '+7 (495) 234-56-78',
      'website': null,
    });
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }
}

