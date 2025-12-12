import '../../../core/models/repair_service_model.dart';
import 'repair_service_dto.dart';

class RepairServiceMapper {
  static RepairServiceModel toModel(RepairServiceDto dto) {
    return RepairServiceModel(
      id: dto.id,
      name: dto.name,
      category: dto.category,
      description: dto.description,
      priceFrom: dto.priceFrom,
      rating: dto.rating,
      contact: dto.contact,
    );
  }

  static RepairServiceDto toDto(RepairServiceModel model) {
    return RepairServiceDto(
      id: model.id,
      name: model.name,
      category: model.category,
      description: model.description,
      priceFrom: model.priceFrom,
      rating: model.rating,
      contact: model.contact,
    );
  }

  static List<RepairServiceModel> toModelList(List<RepairServiceDto> dtos) {
    return dtos.map((dto) => toModel(dto)).toList();
  }
}

