import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id; // ID del usuario en Firestore
  final String name;
  final String lastName;
  final String email;
  final String? phone; // Opcional
  final String? secondName; // Opcional
  final String? secondLastName; // Opcional
  final String? photoUrl; // Agregar esta línea para la URL de la foto
  String rol;
  bool isActive;

  UserModel({
    this.id, // ID opcional
    required this.name,
    required this.lastName,
    required this.email,
    this.phone,
    this.secondName,
    this.secondLastName,
    this.photoUrl, // Asegúrate de incluirlo aquí
    required this.rol, // Agregar esta línea para el rol del usuario
    required this.isActive, // Agregar esta línea para el estado del usuario
  });

  // Método toMap
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'secondName': secondName,
      'secondLastName': secondLastName,
      'photoUrl': photoUrl, // Asegúrate de incluirlo en el map
      'rol': rol, // Agregar esta línea para el rol del usuario
      'isActive': isActive, // Agregar esta línea para el estado del usuario
    };
  }
  Map<String, dynamic> toMapAccount() {
    return {
      "id": id, 
      'name': name,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'secondName': secondName,
      'secondLastName': secondLastName,
      'photoUrl': photoUrl, // Asegúrate de incluirlo en el map
      'rol': rol, // Agregar esta línea para el rol del usuario
      'isActive': isActive, // Agregar esta línea para el estado del usuario
    };
  }

  

  // Método para crear un UserModel desde un Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'],
      secondName: map['secondName'],
      secondLastName: map['secondLastName'],
      photoUrl: map['photoUrl'], // Asegúrate de incluirlo
      rol: map['rol']?? '', // Agregar esta línea para el rol del usuario
      isActive: map['isActive']?? false, // Agregar esta línea para el estado del usuario
    );
  }

  // Método fromDocument para Firestore
/*   factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id, // Asignar el ID del documento
      name: data['name'] ?? '',
      lastName: data['lastName'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'],
      secondName: data['secondName'],
      secondLastName: data['secondLastName'],
      photoUrl: data['photoUrl'], // Asegúrate de incluirlo
      rol: data['rol']?? '', // Agregar esta línea para el rol del usuario
      isActive: data['isActive']?? false, // Agregar esta línea para el estado del usuario
    );
  } */

    factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: data['id'], // Asegúrate de que id sea la cédula del usuario
      name: data['name'] ?? '',
      lastName: data['lastName'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'],
      secondName: data['secondName'],
      secondLastName: data['secondLastName'],
      photoUrl: data['photoUrl'],
      rol: data['rol'] ?? '',
      isActive: data['isActive'] ?? false,
    );
  }
}
