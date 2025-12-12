import '../../../core/models/listing_model.dart';
import '../../interfaces/repositories/listings_repository.dart';

class GetMyListingsUseCase {
  final ListingsRepository repository;

  GetMyListingsUseCase(this.repository);

  Future<List<ListingModel>> call(String ownerId) async {
    return await repository.getMyListings(ownerId);
  }
}

