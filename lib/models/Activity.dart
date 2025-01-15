import 'package:prodtrack/models/user_model.dart';

class Activity {
  String? productId; // ID del producto
  String productName; // Nombre del producto
  int quantity; // Cantidad
  DateTime dateTime; // Fecha y hora de la actividad
  List<UserModel> employees; // Lista de empleados involucrados

  // Constructor
  Activity({
    this.productId,
    required this.productName,
    required this.quantity,
    required this.dateTime,
    required this.employees,
  });

  // Método para convertir la actividad a un mapa (útil para Firebase)
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'dateTime': dateTime.toIso8601String(),
      'employee': employees.map((e) => e.toMap()).toList(),
    };
  }

  // Método para convertir un mapa en una instancia de Activity
  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      productId: map['productId'] as String,
      productName: map['productName'] as String,
      quantity: map['quantity'] as int,
      dateTime: DateTime.parse(map['dateTime'] as String),
      employees: (map['employee'] as List<dynamic>)
          .map((e) => UserModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

