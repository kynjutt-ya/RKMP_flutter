import 'support_ticket_dto.dart';

abstract class SupportDataSource {
  Future<List<SupportTicketDto>> getAllTickets();
  Future<List<SupportTicketDto>> getTicketsByUserId(String userId);
  Future<SupportTicketDto> createTicket(SupportTicketDto ticket);
  Future<SupportTicketDto> updateTicketStatus(String id, String status);
  Future<SupportTicketDto?> getTicketById(String id);
}

class SupportLocalDataSource implements SupportDataSource {
  final List<SupportTicketDto> _tickets = [];

  @override
  Future<List<SupportTicketDto>> getAllTickets() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.from(_tickets);
  }

  @override
  Future<List<SupportTicketDto>> getTicketsByUserId(String userId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _tickets.where((t) => t.userId == userId).toList();
  }

  @override
  Future<SupportTicketDto> createTicket(SupportTicketDto ticket) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _tickets.add(ticket);
    return ticket;
  }

  @override
  Future<SupportTicketDto> updateTicketStatus(String id, String status) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final index = _tickets.indexWhere((t) => t.id == id);
    if (index != -1) {
      final ticket = _tickets[index];
      _tickets[index] = SupportTicketDto(
        id: ticket.id,
        userId: ticket.userId,
        itemId: ticket.itemId,
        category: ticket.category,
        message: ticket.message,
        createdAt: ticket.createdAt,
        status: status,
      );
      return _tickets[index];
    }
    throw Exception('Ticket not found');
  }

  @override
  Future<SupportTicketDto?> getTicketById(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    try {
      return _tickets.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }
}

