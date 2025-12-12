class SupportTicketDto {
  final String id;
  final String userId;
  final String? itemId;
  final String category;
  final String message;
  final DateTime createdAt;
  final String status;

  const SupportTicketDto({
    required this.id,
    required this.userId,
    this.itemId,
    required this.category,
    required this.message,
    required this.createdAt,
    this.status = 'open',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'itemId': itemId,
      'category': category,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }

  factory SupportTicketDto.fromJson(Map<String, dynamic> json) {
    return SupportTicketDto(
      id: json['id'] as String,
      userId: json['userId'] as String,
      itemId: json['itemId'] as String?,
      category: json['category'] as String,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: json['status'] as String? ?? 'open',
    );
  }
}

