import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String id;
  final String userId; // Quem cadastrou
  String title;
  String author;
  String? publisher;
  String? genre;
  String? condition;
  String description;
  String coverUrl;
  String status; // 'available' (disponível) ou 'unavailable' (livrado)
  final DateTime? createdAt;

  Book({
    this.id = '',
    required this.userId,
    required this.title,
    required this.author,
    this.publisher,
    this.genre,
    this.condition,
    required this.description,
    required this.coverUrl,
    this.status = 'available',
    this.createdAt,
  });

  // Converte Objeto -> Mapa (Para salvar no Firebase)
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'author': author,
      'publisher': publisher,
      'genre': genre,
      'condition': condition,
      'description': description,
      'coverUrl': coverUrl,
      'status': status,
      'created_at': FieldValue.serverTimestamp(), // Data automática do servidor
    };
  }

  // Converte Mapa -> Objeto (Para ler do Firebase)
  factory Book.fromMap(Map<String, dynamic> map, String documentId) {
    return Book(
      id: documentId,
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      publisher: map['publisher'],
      genre: map['genre'],
      condition: map['condition'],
      description: map['description'] ?? '',
      coverUrl: map['coverUrl'] ?? '',
      status: map['status'] ?? 'available',
      createdAt: (map['created_at'] as Timestamp?)?.toDate(),
    );
  }
}