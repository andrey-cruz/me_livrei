import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'users';

  Future<void> createUser(UserModel user, String uid) async {
    try {
      await _firestore.collection(_collection).doc(uid).set({
        'fullName': user.fullName,
        'username': user.username,
        'email': user.email,
        'phone': user.phone,
        'state': user.state,
        'city': user.city,
        'genre': user.genre,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Erro ao criar usuário: $e';
    }
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _firestore.collection(_collection).doc(uid).get();
      if (!doc.exists) return null;

      final data = doc.data()!;
      return UserModel(
        id: doc.id,
        fullName: data['fullName'] ?? '',
        username: data['username'] ?? '',
        email: data['email'] ?? '',
        phone: data['phone'] ?? '',
        state: data['state'] ?? '',
        city: data['city'] ?? '',
        genre: data['genre'] ?? '',
        createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
        updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      );
    } catch (e) {
      throw 'Erro ao buscar usuário: $e';
    }
  }

  Future<void> updateUser(String uid, UserModel user) async {
    try {
      await _firestore.collection(_collection).doc(uid).update({
        'fullName': user.fullName,
        'email': user.email,
        'phone': user.phone,
        'state': user.state,
        'city': user.city,
        'genre': user.genre,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Erro ao atualizar usuário: $e';
    }
  }

  Future<void> deleteUser(String uid) async {
    try {
      await _firestore.collection(_collection).doc(uid).delete();
    } catch (e) {
      throw 'Erro ao deletar usuário: $e';
    }
  }

  Stream<UserModel?> streamUser(String uid) {
    return _firestore.collection(_collection).doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;

      final data = doc.data()!;
      return UserModel(
        id: doc.id,
        fullName: data['fullName'] ?? '',
        username: data['username'] ?? '',
        email: data['email'] ?? '',
        phone: data['phone'] ?? '',
        state: data['state'] ?? '',
        city: data['city'] ?? '',
        genre: data['genre'] ?? '',
        createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
        updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      );
    });
  }
}