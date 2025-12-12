import '../core/models/support_ticket_model.dart';
import '../features/support_safety/models/support_ticket.dart';

/// Адаптер для конвертации между SupportTicket (старая модель UI) и SupportTicketModel (Clean Architecture)
class SupportTicketAdapter {
  static SupportTicketModel toModel(SupportTicket ticket) {
    return SupportTicketModel(
      id: ticket.id,
      userId: ticket.userId,
      itemId: ticket.itemId,
      category: ticket.category,
      message: ticket.message,
      createdAt: ticket.createdAt,
      status: ticket.status,
    );
  }

  static SupportTicket toTicket(SupportTicketModel model) {
    return SupportTicket(
      id: model.id,
      userId: model.userId,
      itemId: model.itemId,
      category: model.category,
      message: model.message,
      createdAt: model.createdAt,
      status: model.status,
    );
  }

  static List<SupportTicket> toTicketList(List<SupportTicketModel> models) {
    return models.map((model) => toTicket(model)).toList();
  }

  static List<SupportTicketModel> toModelList(List<SupportTicket> tickets) {
    return tickets.map((ticket) => toModel(ticket)).toList();
  }
}

