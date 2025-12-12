import '../../core/models/listing_model.dart';
import '../../domain/interfaces/repositories/listings_repository.dart';
import '../datasources/listings/listings_datasource.dart';
import '../datasources/listings/listing_mapper.dart';

class ListingsRepositoryImpl implements ListingsRepository {
  final ListingsDataSource dataSource;

  ListingsRepositoryImpl(this.dataSource);

  @override
  Future<List<ListingModel>> getAllListings() async {
    final dtos = await dataSource.getAllListings();
    return ListingMapper.toModelList(dtos);
  }

  @override
  Future<ListingModel?> getListingById(String id) async {
    final dto = await dataSource.getListingById(id);
    return dto != null ? ListingMapper.toModel(dto) : null;
  }

  @override
  Future<ListingModel> addListing(ListingModel listing) async {
    final dto = ListingMapper.toDto(listing);
    final addedDto = await dataSource.addListing(dto);
    return ListingMapper.toModel(addedDto);
  }

  @override
  Future<void> deleteListing(String id) async {
    await dataSource.deleteListing(id);
  }

  @override
  Future<List<ListingModel>> getMyListings(String ownerId) async {
    final dtos = await dataSource.getMyListings(ownerId);
    return ListingMapper.toModelList(dtos);
  }
}

