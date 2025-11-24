import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book.dart';

class BookService {
  final CollectionReference _booksRef =
  FirebaseFirestore.instance.collection('books');

  // 1. CADASTRAR UM NOVO LIVRO
  Future<void> addBook(Book book) async {
    try {
      await _booksRef.add(book.toMap());
    } catch (e) {
      throw Exception('Erro ao adicionar livro: $e');
    }
  }

  // 2. LISTAR TODOS OS LIVROS DISPONÍVEIS
  Future<List<Book>> getAvailableBooks() async {
    try {
      final snapshot = await _booksRef
          .where('status', isEqualTo: 'available')
          .orderBy('created_at', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return Book.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Erro ao buscar livros: $e');
    }
  }

  // 3. LISTAR LIVROS DE UM USUÁRIO ESPECÍFICO
  Future<List<Book>> getUserBooks(String userId) async {
    try {
      final snapshot = await _booksRef
          .where('userId', isEqualTo: userId)
          .orderBy('created_at', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return Book.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Erro ao buscar seus livros: $e');
    }
  }

  // 4. ATUALIZAR DADOS DO LIVRO
  Future<void> updateBook(String bookId, Book updatedBook) async {
    try {
      final data = updatedBook.toMap();
      data.remove('userId');
      data.remove('created_at');

      await _booksRef.doc(bookId).update(data);
    } catch (e) {
      throw Exception('Erro ao atualizar livro: $e');
    }
  }

  // 5. MUDAR STATUS
  Future<void> updateBookStatus(String bookId, String newStatus) async {
    try {
      await _booksRef.doc(bookId).update({'status': newStatus});
    } catch (e) {
      throw Exception('Erro ao atualizar status: $e');
    }
  }

  // 6. DELETAR LIVRO
  Future<void> deleteBook(String bookId) async {
    try {
      await _booksRef.doc(bookId).delete();
    } catch (e) {
      throw Exception('Erro ao deletar livro: $e');
    }
  }

  // 7. BUSCAR VÁRIOS LIVROS POR LISTA DE IDs (NOVO)
  Future<List<Book>> getBooksByIds(List<String> ids) async {
    if (ids.isEmpty) return [];

    try {
      List<Book> books = [];
      // O Firestore limita o 'whereIn' a 10 itens. Vamos fazer em lotes.
      for (var i = 0; i < ids.length; i += 10) {
        var end = (i + 10 < ids.length) ? i + 10 : ids.length;
        var chunk = ids.sublist(i, end);

        final snapshot = await _booksRef
            .where(FieldPath.documentId, whereIn: chunk)
            .get();

        books.addAll(snapshot.docs.map((doc) {
          return Book.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }));
      }
      return books;
    } catch (e) {
      return [];
    }
  }
}