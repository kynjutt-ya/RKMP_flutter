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
}
