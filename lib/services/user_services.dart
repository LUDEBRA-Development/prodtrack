import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prodtrack/models/user_model.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtener usuario actual
  User? get currentUser => _auth.currentUser;

  // Obtener un usuario por ID
  Future<UserModel?> getUserById(String id) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(id).get();
    if (doc.exists) {
      return UserModel.fromDocument(doc);
    }
    return null; // Si no existe, retornar null
  }

  
/*   Future<void> updateUser(UserModel user) async {
    await _firestore.collection('users').doc(user.id).update(user.toMap());
  } */
  Future<void> updateUser(UserModel user) async {
    // Buscar el documento que tenga la cédula especificada en `user.id`
    final querySnapshot = await _firestore
        .collection('users')
        .where('id', isEqualTo: user.id)
        .get();

    // Verificar si se encontró un documento
    if (querySnapshot.docs.isNotEmpty) {
      final docId = querySnapshot.docs.first.id; // Obtener el ID del documento

      // Actualizar el documento usando el ID encontrado
      await _firestore.collection('users').doc(docId).update(user.toMap());
    } else {
      throw Exception('Usuario con cédula ${user.id} no encontrado.');
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();

      return querySnapshot.docs.map((doc) {
        return UserModel.fromDocument(doc);
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
