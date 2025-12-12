import '../../../core/models/listing_model.dart';

abstract class ListingsRepository {

  Future<List<ListingModel>> getAllListings();

  Future<ListingModel?> getListingById(String id);

  Future<ListingModel> addListing(ListingModel listing);

  Future<void> deleteListing(String id);

  Future<List<ListingModel>> getMyListings(String ownerId);
}

