import '../../../core/models/support_ticket_model.dart';
import 'support_ticket_dto.dart';

class SupportTicketMapper {
  static SupportTicketModel toModel(SupportTicketDto dto) {
    return SupportTicketModel(
      id: dto.id,
      userId: dto.userId,
      itemId: dto.itemId,
      category: dto.category,
      message: dto.message,
      createdAt: dto.createdAt,
      status: dto.status,
    );
  }

  static SupportTicketDto toDto(SupportTicketModel model) {
    return SupportTicketDto(
      id: model.id,
      userId: model.userId,
      itemId: model.itemId,
      category: model.category,
      message: model.message,
      createdAt: model.createdAt,
      status: model.status,
    );
  }

  static List<SupportTicketModel> toModelList(List<SupportTicketDto> dtos) {
    return dtos.map((dto) => toModel(dto)).toList();
  }
}

