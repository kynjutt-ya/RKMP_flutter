import '../../core/models/support_ticket_model.dart';
import '../../domain/interfaces/repositories/support_repository.dart';
import '../datasources/support/support_local_data_source.dart';
import '../datasources/support/support_ticket_mapper.dart';

class SupportRepositoryImpl implements SupportRepository {
  final SupportDataSource dataSource;

  SupportRepositoryImpl(this.dataSource);

  @override
  Future<List<SupportTicketModel>> getAllTickets() async {
    final dtos = await dataSource.getAllTickets();
    return SupportTicketMapper.toModelList(dtos);
  }

  @override
  Future<List<SupportTicketModel>> getTicketsByUserId(String userId) async {
    final dtos = await dataSource.getTicketsByUserId(userId);
    return SupportTicketMapper.toModelList(dtos);
  }

  @override
  Future<SupportTicketModel> createTicket(SupportTicketModel ticket) async {
    final dto = SupportTicketMapper.toDto(ticket);
    final createdDto = await dataSource.createTicket(dto);
    return SupportTicketMapper.toModel(createdDto);
  }

  @override
  Future<SupportTicketModel> updateTicketStatus(String id, String status) async {
    final dto = await dataSource.updateTicketStatus(id, status);
    return SupportTicketMapper.toModel(dto);
  }

  @override
  Future<SupportTicketModel?> getTicketById(String id) async {
    final dto = await dataSource.getTicketById(id);
    return dto != null ? SupportTicketMapper.toModel(dto) : null;
  }
}

