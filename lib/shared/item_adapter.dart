import '../core/models/listing_model.dart';
import '../features/listings/models/item.dart';

/// Адаптер для преобразования между Item (старая модель) и ListingModel (новая доменная модель)
/// Используется для обратной совместимости при миграции на Clean Architecture
class ItemAdapter {
  /// Преобразование Item в ListingModel
  static ListingModel toModel(Item item) {
    return ListingModel(
      id: item.id,
      title: item.title,
      description: item.description,
      forExchange: item.forExchange,
      ownerId: item.ownerId,
      owner: item.owner,
      imageUrl: item.imageUrl,
      imagePath: item.imagePath,
      imageBytes: item.imageBytes,
      category: item.category,
      createdAt: item.createdAt,
      condition: item.condition,
    );
  }

  /// Преобразование ListingModel в Item
  static Item toItem(ListingModel model) {
    return Item(
      id: model.id,
      title: model.title,
      description: model.description,
      forExchange: model.forExchange,
      ownerId: model.ownerId,
      owner: model.owner,
      imageUrl: model.imageUrl,
      imagePath: model.imagePath,
      imageBytes: model.imageBytes,
      category: model.category,
      createdAt: model.createdAt,
      condition: model.condition,
    );
  }

  /// Преобразование списка Item в список ListingModel
  static List<ListingModel> toModelList(List<Item> items) {
    return items.map((item) => toModel(item)).toList();
  }

  /// Преобразование списка ListingModel в список Item
  static List<Item> toItemList(List<ListingModel> models) {
    return models.map((model) => toItem(model)).toList();
  }
}

