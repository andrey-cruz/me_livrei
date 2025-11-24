import 'package:cloud_firestore/cloud_firestore.dart';

class InterestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'interests';

  Future<void> addInterest({
    required String bookId,
    required String bookTitle,
    required String userId,
    required String userName,
    required String userEmail,
    required String ownerId,
  }) async {
    try {
      await _firestore.collection(_collection).add({
        'bookId': bookId,
        'bookTitle': bookTitle,
        'userId': userId,
        'userName': userName,
        'userEmail': userEmail,
        'ownerId': ownerId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Erro ao demonstrar interesse: $e';
    }
  }

  Future<bool> hasUserInterest({
    required String userId,
    required String bookId,
  }) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('bookId', isEqualTo: bookId)
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<void> removeInterest({
    required String userId,
    required String bookId,
  }) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('bookId', isEqualTo: bookId)
          .get();

      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw 'Erro ao cancelar interesse: $e';
    }
  }

  Future<List<Map<String, dynamic>>> getBookInterests(String bookId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('bookId', isEqualTo: bookId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'userId': data['userId'] ?? '',
          'userName': data['userName'] ?? '',
          'userEmail': data['userEmail'] ?? '',
          'createdAt': data['createdAt'],
        };
      }).toList();
    } catch (e) {
      throw 'Erro ao buscar interessados: $e';
    }
  }

  Future<int> getBookInterestCount(String bookId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('bookId', isEqualTo: bookId)
          .get();

      return snapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }

  Stream<List<Map<String, dynamic>>> streamBookInterests(String bookId) {
    return _firestore
        .collection(_collection)
        .where('bookId', isEqualTo: bookId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'userId': data['userId'] ?? '',
          'userName': data['userName'] ?? '',
          'userEmail': data['userEmail'] ?? '',
          'createdAt': data['createdAt'],
        };
      }).toList();
    });
  }
}