import 'package:get_it/get_it.dart';
import 'features/listings/models/item.dart';

final GetIt locator = GetIt.instance;

class AppStateService {
  List<Item> allItems = [];
  List<Item> userItems = [];

  void initializeDemoData() {
    allItems.addAll([
      Item(
        id: '1',
        title: 'Настольная лампа',
        description: 'Современная настольная лампа в хорошем состоянии',
        forExchange: false,
        owner: 'Алексей',
        imagePath: 'https://cdn1.ozone.ru/s3/multimedia-c/6397661772.jpg',
      ),
      Item(
        id: '2',
        title: 'Кресло',
        description: 'Мягкое офисное кресло, возможен обмен',
        forExchange: true,
        owner: 'Ирина',
        imagePath: 'https://avatars.mds.yandex.net/get-mpic/12366926/2a00000193f6a60316c7671dbd7ce04821a8/orig',
      ),
      Item(
        id: '3',
        title: 'Полка для книг',
        description: 'Деревянная полка, отличное состояние',
        forExchange: false,
        owner: 'Михаил',
        imagePath: 'https://avatars.mds.yandex.net/i?id=86d5887e8ef7cbf34155b28dc5aac7b5_l-4483413-images-thumbs&n=13',
      ),
      Item(
        id: '4',
        title: 'Кофеварка',
        description: 'Рабочая, отдам даром',
        forExchange: false,
        owner: 'Ольга',
        imagePath: 'https://avatars.mds.yandex.net/get-mpic/5313421/img_id5674444383649941535.jpeg/orig',
      ),
      Item(
        id: '5',
        title: 'Монитор',
        description: '24 дюйма, немного потерто, работает отлично',
        forExchange: true,
        owner: 'Павел',
        imagePath: 'https://avatars.mds.yandex.net/i?id=df9f7f4bb3c0035b0ef5f4ddb58bd6f0_l-3708982-images-thumbs&n=13',
      ),
    ]);
    userItems = [];
  }

  void addItem(Item item) {
    userItems.add(item);
    allItems.add(item);
  }

  void removeItem(String id) {
    userItems.removeWhere((it) => it.id == id);
    allItems.removeWhere((it) => it.id == id);
  }
}

class MyClass {
  final String name = "MyClass Instance";
}

class BackupService {
  List<Item> backupItems = [];

  void saveBackup(List<Item> items) {
    backupItems = List.from(items);
  }

  List<Item> restoreBackup() {
    return List.from(backupItems);
  }
}

class LoggerService {
  final String _prefix;
  LoggerService(this._prefix);

  void log(String message) {
    print('[$_prefix] $message');
  }
}

void setupLocator() {
  locator.allowReassignment = true;

  locator.registerSingleton<AppStateService>(AppStateService()..initializeDemoData());

  locator.registerSingleton<MyClass>(MyClass(), instanceName: 'my_class');
  locator.registerSingleton<BackupService>(BackupService(), instanceName: 'user_backup');
  locator.registerSingleton<BackupService>(BackupService(), instanceName: 'system_backup');

  locator.registerLazySingleton<AppStateService>(() {
    final service = AppStateService();
    service.initializeDemoData();
    print('Lazy AppStateService initialized');
    return service;
  }, instanceName: 'lazy_state');

  locator.registerFactory<MyClass>(() => MyClass(), instanceName: 'my_class_factory');

  locator.registerFactoryParam<LoggerService, String, void>((name, _) => LoggerService(name));
}