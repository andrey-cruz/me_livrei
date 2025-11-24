import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/book.dart';

class BookService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  static const String _collection = 'books';

  Future<String> createBook(Book book, {File? coverImage}) async {
    try {
      String? coverUrl = book.coverUrl;

      if (coverImage != null) {
        coverUrl = await _uploadCover(book.userId, coverImage);
      }

      final docRef = await _firestore.collection(_collection).add({
        'userId': book.userId,
        'title': book.title,
        'author': book.author,
        'publisher': book.publisher,
        'genre': book.genre,
        'condition': book.condition,
        'description': book.description,
        'coverUrl': coverUrl,
        'status': 'available',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return docRef.id;
    } catch (e) {
      throw 'Erro ao criar livro: $e';
    }
  }

  Future<Book?> getBook(String bookId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(bookId).get();
      if (!doc.exists) return null;

      final data = doc.data()!;
      return Book(
        id: doc.id,
        userId: data['userId'] ?? '',
        title: data['title'] ?? '',
        author: data['author'] ?? '',
        publisher: data['publisher'],
        genre: data['genre'],
        condition: data['condition'],
        description: data['description'] ?? '',
        coverUrl: data['coverUrl'] ?? '',
      );
    } catch (e) {
      throw 'Erro ao buscar livro: $e';
    }
  }

  Future<List<Book>> getAvailableBooks() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('status', isEqualTo: 'available')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Book(
          id: doc.id,
          userId: data['userId'] ?? '',
          title: data['title'] ?? '',
          author: data['author'] ?? '',
          publisher: data['publisher'],
          genre: data['genre'],
          condition: data['condition'],
          description: data['description'] ?? '',
          coverUrl: data['coverUrl'] ?? '',
        );
      }).toList();
    } catch (e) {
      throw 'Erro ao buscar livros: $e';
    }
  }

  Future<List<Book>> getUserBooks(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Book(
          id: doc.id,
          userId: data['userId'] ?? '',
          title: data['title'] ?? '',
          author: data['author'] ?? '',
          publisher: data['publisher'],
          genre: data['genre'],
          condition: data['condition'],
          description: data['description'] ?? '',
          coverUrl: data['coverUrl'] ?? '',
        );
      }).toList();
    } catch (e) {
      throw 'Erro ao buscar livros do usuário: $e';
    }
  }

  Future<void> updateBook(String bookId, Book book, {File? newCoverImage}) async {
    try {
      String? coverUrl = book.coverUrl;

      if (newCoverImage != null) {
        coverUrl = await _uploadCover(book.userId, newCoverImage);
      }

      await _firestore.collection(_collection).doc(bookId).update({
        'title': book.title,
        'author': book.author,
        'publisher': book.publisher,
        'genre': book.genre,
        'condition': book.condition,
        'description': book.description,
        'coverUrl': coverUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Erro ao atualizar livro: $e';
    }
  }

  Future<void> updateBookStatus(String bookId, String status) async {
    try {
      await _firestore.collection(_collection).doc(bookId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Erro ao atualizar status: $e';
    }
  }

  Future<void> deleteBook(String bookId) async {
    try {
      final book = await getBook(bookId);
      if (book != null && book.coverUrl.isNotEmpty) {
        try {
          await _storage.refFromURL(book.coverUrl).delete();
        } catch (_) {}
      }

      await _firestore.collection(_collection).doc(bookId).delete();
    } catch (e) {
      throw 'Erro ao deletar livro: $e';
    }
  }

  Stream<List<Book>> streamAvailableBooks() {
    return _firestore
        .collection(_collection)
        .where('status', isEqualTo: 'available')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Book(
          id: doc.id,
          userId: data['userId'] ?? '',
          title: data['title'] ?? '',
          author: data['author'] ?? '',
          publisher: data['publisher'],
          genre: data['genre'],
          condition: data['condition'],
          description: data['description'] ?? '',
          coverUrl: data['coverUrl'] ?? '',
        );
      }).toList();
    });
  }

  Future<String> _uploadCover(String userId, File image) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final ref = _storage.ref().child('book_covers/$userId/cover_$timestamp.jpg');
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } catch (e) {
      throw 'Erro ao fazer upload da capa: $e';
    }
  }
}