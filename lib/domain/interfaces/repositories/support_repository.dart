import '../../../core/models/support_ticket_model.dart';

abstract class SupportRepository {
  Future<List<SupportTicketModel>> getAllTickets();
  Future<List<SupportTicketModel>> getTicketsByUserId(String userId);
  Future<SupportTicketModel> createTicket(SupportTicketModel ticket);
  Future<SupportTicketModel> updateTicketStatus(String id, String status);
  Future<SupportTicketModel?> getTicketById(String id);
}

