import '../../../core/models/listing_model.dart';
import '../../interfaces/repositories/listings_repository.dart';

/// Use case для получения объявления по ID
/// Инкапсулирует бизнес-логику поиска объявления
class GetListingByIdUseCase {
  final ListingsRepository repository;

  GetListingByIdUseCase(this.repository);

  /// Выполнить use case
  /// Возвращает null, если объявление не найдено
  Future<ListingModel?> call(String id) async {
    if (id.isEmpty) {
      return null;
    }
    return await repository.getListingById(id);
  }
}

