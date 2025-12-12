import 'package:sqflite/sqflite.dart';
import '../../database/database_helper.dart';
import 'support_ticket_dto.dart';

abstract class SupportDataSource {
  Future<List<SupportTicketDto>> getAllTickets();
  Future<List<SupportTicketDto>> getTicketsByUserId(String userId);
  Future<SupportTicketDto> createTicket(SupportTicketDto ticket);
  Future<SupportTicketDto> updateTicketStatus(String id, String status);
  Future<SupportTicketDto?> getTicketById(String id);
}

class SQLiteSupportDataSource implements SupportDataSource {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  Future<List<SupportTicketDto>> getAllTickets() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'support_tickets',
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) => _mapToTicketDto(maps[i]));
  }

  @override
  Future<List<SupportTicketDto>> getTicketsByUserId(String userId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'support_tickets',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) => _mapToTicketDto(maps[i]));
  }

  @override
  Future<SupportTicketDto> createTicket(SupportTicketDto ticket) async {
    final db = await _dbHelper.database;
    await db.insert(
      'support_tickets',
      _ticketDtoToMap(ticket),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return ticket;
  }

  @override
  Future<SupportTicketDto> updateTicketStatus(String id, String status) async {
    final db = await _dbHelper.database;
    await db.update(
      'support_tickets',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
    final updated = await getTicketById(id);
    if (updated == null) {
      throw Exception('Ticket not found');
    }
    return updated;
  }

  @override
  Future<SupportTicketDto?> getTicketById(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'support_tickets',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return _mapToTicketDto(maps.first);
  }

  Map<String, dynamic> _ticketDtoToMap(SupportTicketDto dto) {
    return {
      'id': dto.id,
      'userId': dto.userId,
      'itemId': dto.itemId,
      'category': dto.category,
      'message': dto.message,
      'createdAt': dto.createdAt.toIso8601String(),
      'status': dto.status,
    };
  }

  SupportTicketDto _mapToTicketDto(Map<String, dynamic> map) {
    return SupportTicketDto(
      id: map['id'] as String,
      userId: map['userId'] as String,
      itemId: map['itemId'] as String?,
      category: map['category'] as String,
      message: map['message'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      status: map['status'] as String,
    );
  }
}

