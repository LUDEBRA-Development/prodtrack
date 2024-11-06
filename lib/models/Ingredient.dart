import 'package:prodtrack/models/Supplier.dart';
import 'package:prodtrack/models/Und.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Ingredient {
  String? id; // final String id
  final String name;
  double quantityUsed;
  double quantityInInventory;
  final double price;
  final Supplier supplier;
  final Und und;

  Ingredient(
      {this.id,
      required this.name,
      required this.quantityUsed,
      required this.quantityInInventory,
      required this.supplier,
      required this.und,
      required this.price});

  get totalPrice {
    return quantityUsed * price;
  }

// Método toMap
  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'name': name,
  //     'quantityUsed': quantityUsed,
  //     'quantityInInventory': quantityInInventory,
  //     'supplier': supplier,
  //     'und': und,
  //     'price': price,
  //   };
  // }

  // Nuevo toMap
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantityUsed': quantityUsed,
      'quantityInInventory': quantityInInventory,
      'price': price,
      'supplier': supplier.toMap(), // Convertir el supplier a mapa
      'und': und.toMap(), // Convertir el und a mapa
    };
  }

  // Método para crear un Supplier desde un Map
  // factory Ingredient.fromMap(Map<String, dynamic> map) {
  //   return Ingredient(
  //     id: map['id'] ?? '', // Asigna el ID si está presente
  //     name: map['name'] ?? '',
  //     quantityUsed: map['quantityUsed'] ?? '',
  //     quantityInInventory: map['quantityInInventory'] ?? '',
  //     supplier: map['supplier'] ?? '',
  //     und: map['und'] ?? '',
  //     price: map['price'] ?? '',
  //   );
  // }

  // factory Ingredient.fromDocument(DocumentSnapshot doc) {
  //   final data = doc.data() as Map<String, dynamic>;
  //   return Ingredient(
  //     id: doc.id, // Asignar el ID del documento
  //     name: data['name'] ?? '',
  //     quantityUsed: data['quantityUsed'] ?? '',
  //     quantityInInventory: data['quantityInInventory'] ?? '',
  //     supplier: data['supplier'] ?? '',
  //     und: data['und'] ?? '',
  //     price: data['price'] ?? '',
  //   );
  // }

  // Nuevo codigo
  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      quantityUsed:
          (map['quantityUsed'] as num).toDouble(), // Convertir a double
      quantityInInventory: (map['quantityInInventory'] as num).toDouble(),
      price: (map['price'] as num).toDouble(),
      supplier:
          Supplier.fromMap(map['supplier']), // Convertir supplier desde un mapa
      und: Und.fromMap(map['und']), // Convertir und desde un mapa
    );
  }

  factory Ingredient.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Ingredient(
      id: doc.id,
      name: data['name'] ?? '',
      quantityUsed: (data['quantityUsed'] as num).toDouble(),
      quantityInInventory: (data['quantityInInventory'] as num).toDouble(),
      price: (data['price'] as num).toDouble(),
      supplier: Supplier.fromMap(data['supplier']),
      und: Und.fromMap(data['und']),
    );
  }
}
