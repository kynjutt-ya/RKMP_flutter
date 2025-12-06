class SupportTicket {
  final String id;
  final String userId;
  final String? itemId;
  final String category; // scam, dangerous_item, harassment
  final String message;
  final DateTime createdAt;
  final String status; // open, in_progress, resolved

  SupportTicket({
    required this.id,
    required this.userId,
    this.itemId,
    required this.category,
    required this.message,
    DateTime? createdAt,
    this.status = 'open',
  }) : createdAt = createdAt ?? DateTime.now();

  SupportTicket copyWith({
    String? id,
    String? userId,
    String? itemId,
    String? category,
    String? message,
    DateTime? createdAt,
    String? status,
  }) {
    return SupportTicket(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      itemId: itemId ?? this.itemId,
      category: category ?? this.category,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }
}

