import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para registrar un usuario con correo y contraseña
  Future<User?> registerWithEmail(String email, String password, String name,
      String lastName, String id) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      // Si el usuario se crea correctamente, guarda los datos en Firestore
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'lastName': lastName,
          'id': id,
          'createdAt': FieldValue.serverTimestamp(),
          'rol' : 'usuario',
          'isActive' : false
        });
      }

      return user;
    } catch (e) {
      print("Error en el registro: $e");
      return null;
    }
  }

  // Método para iniciar sesión con correo y contraseña
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error en el inicio de sesión: $e");
      return null;
    }
  }

  // Obtener el nombre del usuario desde Firestore
  Future<String?> getUserName() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        return userDoc['name']; // Devuelve el nombre del usuario
      }
      return null;
    } catch (e) {
      print("Error al obtener el nombre del usuario: $e");
      return null;
    }
  }
  
  Future<Map<String, dynamic>?> getUserRoleAndStatus() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

        // Verifica si el documento existe
        if (userDoc.exists) {
          String role = userDoc['rol']; // Obtiene el rol del usuario
          bool isActive = userDoc['isActive']; // Obtiene el estado del usuario

          // Retorna el rol y el estado en un mapa
          return {'rol': role, 'isActive': isActive};
        }
      }
      return null;
    } catch (e) {
      print("Error al obtener el rol y el estado del usuario: $e");
      return null;
    }
  }

  // Método para cerrar sesión
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error al cerrar sesión: $e");
    }
  }

  // Obtener usuario actual
  User? get currentUser {
    return _auth.currentUser;
  }
}
