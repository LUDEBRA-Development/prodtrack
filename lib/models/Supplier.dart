import 'package:cloud_firestore/cloud_firestore.dart';

class Supplier {
  String? id; // El ID que se asignará desde Firestore
  final String name;
  final String phone;
  final String gmail;
  final String? webSite;
  final String address;
  final String nit;
  final String? urlProfilePhoto;

  Supplier({
    this.id, // Agrega el id como un parámetro opcional
    required this.name,
    required this.phone,
    required this.gmail,
    required this.webSite,
    required this.address,
    required this.nit,
    this.urlProfilePhoto,
  });

  // Método toMap
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'gmail': gmail,
      'webSite': webSite,
      'address': address,
      'nit': nit,
      'urlProfilePhoto': urlProfilePhoto,
    };
  }

  // Método para crear un Supplier desde un Map
  factory Supplier.fromMap(Map<String, dynamic> map) {
    return Supplier(
      id: map['id'] ?? '', // Asigna el ID si está presente
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      gmail: map['gmail'] ?? '',
      webSite: map['webSite'] ?? '',
      address: map['address'] ?? '',
      nit: map['nit'] ?? '',
      urlProfilePhoto: map['urlProfilePhoto'] ?? '',
    );
  }

  // Método fromDocument para Firestore
  factory Supplier.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Supplier(
      id: doc.id, // Asignar el ID del documento
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      gmail: data['gmail'] ?? '',
      webSite: data['webSite'] ?? '',
      address: data['address'] ?? '',
      nit: data['nit'] ?? '',
      urlProfilePhoto: data['urlProfilePhoto'] ?? '',
    );
  }
}
