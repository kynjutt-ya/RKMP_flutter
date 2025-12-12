class EcoTipDto {
  final String id;
  final String title;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;

  const EcoTipDto({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory EcoTipDto.fromJson(Map<String, dynamic> json) {
    return EcoTipDto(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrl: json['imageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

