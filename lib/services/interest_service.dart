import 'package:cloud_firestore/cloud_firestore.dart';

class InterestService {
  final CollectionReference _interestsRef =
  FirebaseFirestore.instance.collection('interests');

  // 1. DEMONSTRAR INTERESSE
  Future<void> addInterest({
    required String bookId,
    required String bookTitle,
    required String userId,
    required String userName,
    required String userEmail,
    required String ownerId,
  }) async {
    try {
      await _interestsRef.add({
        'bookId': bookId,
        'bookTitle': bookTitle,
        'userId': userId,
        'userName': userName,
        'userEmail': userEmail,
        'ownerId': ownerId,
        'created_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Erro ao demonstrar interesse: $e');
    }
  }

  // 2. REMOVER INTERESSE
  Future<void> removeInterest({
    required String userId,
    required String bookId,
  }) async {
    try {
      final snapshot = await _interestsRef
          .where('userId', isEqualTo: userId)
          .where('bookId', isEqualTo: bookId)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Erro ao remover interesse: $e');
    }
  }

  // 3. VERIFICAR SE O USUÁRIO JÁ TEM INTERESSE
  Future<bool> hasUserInterest({
    required String userId,
    required String bookId,
  }) async {
    try {
      final snapshot = await _interestsRef
          .where('userId', isEqualTo: userId)
          .where('bookId', isEqualTo: bookId)
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // 4. CONTAR QUANTOS INTERESSADOS O LIVRO TEM
  Future<int> getBookInterestCount(String bookId) async {
    try {
      final snapshot = await _interestsRef
          .where('bookId', isEqualTo: bookId)
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // 5. LISTAR QUEM SÃO OS INTERESSADOS
  Future<List<Map<String, dynamic>>> getBookInterests(String bookId) async {
    try {
      final snapshot = await _interestsRef
          .where('bookId', isEqualTo: bookId)
          .orderBy('created_at', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // 6. BUSCAR IDs DOS LIVROS QUE O USUÁRIO CURTIU (NOVO)
  Future<List<String>> getUserInterestedBookIds(String userId) async {
    try {
      final snapshot = await _interestsRef
          .where('userId', isEqualTo: userId)
          .orderBy('created_at', descending: true)
          .get();

      return snapshot.docs.map((doc) => doc['bookId'] as String).toList();
    } catch (e) {
      return [];
    }
  }
}