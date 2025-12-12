import 'listing_dto.dart';

abstract class ListingsDataSource {
  Future<List<ListingDto>> getAllListings();
  Future<ListingDto?> getListingById(String id);
  Future<ListingDto> addListing(ListingDto listing);
  Future<void> deleteListing(String id);
  Future<List<ListingDto>> getMyListings(String ownerId);
}

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

