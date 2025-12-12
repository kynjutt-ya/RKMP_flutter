import '../../../core/models/listing_model.dart';
import 'listing_dto.dart';

class ListingMapper {

  static ListingModel toModel(ListingDto dto) {
    return ListingModel(
      id: dto.id,
      title: dto.title,
      description: dto.description,
      forExchange: dto.forExchange,
      ownerId: dto.ownerId,
      owner: dto.owner,
      imageUrl: dto.imageUrl,
      imagePath: dto.imagePath,
      imageBytes: dto.imageBytes,
      category: dto.category,
      createdAt: dto.createdAt,
      condition: dto.condition,
    );
  }

  static ListingDto toDto(ListingModel model) {
    return ListingDto(
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

  static List<ListingModel> toModelList(List<ListingDto> dtos) {
    return dtos.map((dto) => toModel(dto)).toList();
  }

  static List<ListingDto> toDtoList(List<ListingModel> models) {
    return models.map((model) => toDto(model)).toList();
  }
}

