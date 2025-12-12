import '../../../core/models/support_ticket_model.dart';
import '../../interfaces/repositories/support_repository.dart';

class CreateTicketUseCase {
  final SupportRepository repository;

  CreateTicketUseCase(this.repository);

  Future<SupportTicketModel> call(SupportTicketModel ticket) async {
    if (ticket.userId.isEmpty) {
      throw Exception('ID пользователя не может быть пустым');
    }
    if (ticket.message.trim().isEmpty) {
      throw Exception('Сообщение не может быть пустым');
    }
    if (ticket.category.isEmpty) {
      throw Exception('Категория не может быть пустой');
    }
    return await repository.createTicket(ticket);
  }
}

