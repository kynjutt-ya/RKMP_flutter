import '../../../core/models/eco_tip_model.dart';
import '../../../core/models/recycling_point_model.dart';
import 'eco_tip_dto.dart';
import 'recycling_point_dto.dart';

class EcoGuideMapper {
  static EcoTipModel tipToModel(EcoTipDto dto) {
    return EcoTipModel(
      id: dto.id,
      title: dto.title,
      content: dto.content,
      imageUrl: dto.imageUrl,
      createdAt: dto.createdAt,
    );
  }

  static EcoTipDto tipToDto(EcoTipModel model) {
    return EcoTipDto(
      id: model.id,
      title: model.title,
      content: model.content,
      imageUrl: model.imageUrl,
      createdAt: model.createdAt,
    );
  }

  static RecyclingPointModel pointToModel(RecyclingPointDto dto) {
    return RecyclingPointModel(
      id: dto.id,
      name: dto.name,
      address: dto.address,
      phone: dto.phone,
      acceptedTypes: dto.acceptedTypes,
      latitude: dto.latitude,
      longitude: dto.longitude,
    );
  }

  static RecyclingPointDto pointToDto(RecyclingPointModel model) {
    return RecyclingPointDto(
      id: model.id,
      name: model.name,
      address: model.address,
      phone: model.phone,
      acceptedTypes: model.acceptedTypes,
      latitude: model.latitude,
      longitude: model.longitude,
    );
  }

  static List<EcoTipModel> tipToModelList(List<EcoTipDto> dtos) {
    return dtos.map((dto) => tipToModel(dto)).toList();
  }

  static List<RecyclingPointModel> pointToModelList(List<RecyclingPointDto> dtos) {
    return dtos.map((dto) => pointToModel(dto)).toList();
  }
}

