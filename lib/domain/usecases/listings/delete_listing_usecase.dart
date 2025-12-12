import '../../interfaces/repositories/listings_repository.dart';

/// Use case для удаления объявления
/// Инкапсулирует бизнес-логику удаления объявления
class DeleteListingUseCase {
  final ListingsRepository repository;

  DeleteListingUseCase(this.repository);

  /// Выполнить use case
  Future<void> call(String id) async {
    if (id.isEmpty) {
      throw Exception('ID объявления не может быть пустым');
    }
    await repository.deleteListing(id);
  }
}

