import '../../../core/models/listing_model.dart';
import '../../interfaces/repositories/listings_repository.dart';


class AddListingUseCase {
  final ListingsRepository repository;

  AddListingUseCase(this.repository);


  Future<ListingModel> call(ListingModel listing) async {
    if (listing.title.trim().isEmpty) {
      throw Exception('Название объявления не может быть пустым');
    }
    if (listing.description.trim().isEmpty) {
      throw Exception('Описание объявления не может быть пустым');
    }
    if (listing.ownerId.isEmpty) {
      throw Exception('ID владельца не может быть пустым');
    }

    return await repository.addListing(listing);
  }
}

