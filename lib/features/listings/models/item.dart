class Item {
  final String id;
  final String title;
  final String description;
  final bool forExchange;
  final String owner;
  final String? imagePath;

  Item({
    required this.id,
    required this.title,
    required this.description,
    required this.forExchange,
    required this.owner,
    this.imagePath,
  });

  Item copyWith({
    String? id,
    String? title,
    String? description,
    bool? forExchange,
    String? owner,
    String? imagePath,
  }) {
    return Item(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      forExchange: forExchange ?? this.forExchange,
      owner: owner ?? this.owner,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
