class Book {
  final String id;
  final String userId;
  String title;
  String author;
  String? publisher;
  String? genre;
  String? condition;
  String description;
  String coverUrl;

  Book({
    required this.id,
    required this.userId,
    required this.title,
    required this.author,
    this.publisher,
    this.genre,
    this.condition,
    required this.description,
    required this.coverUrl,
  });
}
