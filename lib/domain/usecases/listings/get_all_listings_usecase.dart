import '../../../core/models/listing_model.dart';
import '../../interfaces/repositories/listings_repository.dart';


class GetAllListingsUseCase {
  final ListingsRepository repository;

  GetAllListingsUseCase(this.repository);

  Future<List<ListingModel>> call() async {
    return await repository.getAllListings();
  }
}

