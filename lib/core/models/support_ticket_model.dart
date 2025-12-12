class SupportTicketModel {
  final String id;
  final String userId;
  final String? itemId;
  final String category;
  final String message;
  final DateTime createdAt;
  final String status;

  const SupportTicketModel({
    required this.id,
    required this.userId,
    this.itemId,
    required this.category,
    required this.message,
    required this.createdAt,
    this.status = 'open',
  });

  SupportTicketModel copyWith({
    String? id,
    String? userId,
    String? itemId,
    String? category,
    String? message,
    DateTime? createdAt,
    String? status,
  }) {
    return SupportTicketModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      itemId: itemId ?? this.itemId,
      category: category ?? this.category,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SupportTicketModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

