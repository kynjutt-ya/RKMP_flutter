import '../../../core/models/support_ticket_model.dart';
import '../../interfaces/repositories/support_repository.dart';

class GetAllTicketsUseCase {
  final SupportRepository repository;

  GetAllTicketsUseCase(this.repository);

  Future<List<SupportTicketModel>> call() async {
    return await repository.getAllTickets();
  }
}

