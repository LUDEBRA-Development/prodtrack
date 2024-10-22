import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prodtrack/models/Supplier.dart';
import 'package:prodtrack/models/employee.dart';
import 'package:intl/intl.dart';

class AccountPayable {
  String? id; // ID de Firestore
  final dynamic beneficiary; // Puede ser Supplier o Employee
  final DateTime dueDate;
  final double amount;
  bool isPaid;

  AccountPayable({
    this.id, // La ID es requerida, pero puede ser asignada después al crearla en Firestore
    required this.beneficiary,
    required this.dueDate,
    required this.amount,
    this.isPaid = false,
  });

  // Método para convertir la clase a un formato Map (JSON) para Firestore
  Map<String, dynamic> toMap() {
    return {
      'beneficiaryType': beneficiary is Supplier ? 'Supplier' : 'Employee',
      'beneficiary': beneficiary is Supplier
          ? (beneficiary as Supplier).toMap()
          : (beneficiary as Employee).toMap(),
      'dueDate': dueDate.toIso8601String(),
      'amount': amount,
      'isPaid': isPaid,
    };
  }

  // Método estático para crear una instancia desde un Map (Firestore snapshot)
  factory AccountPayable.fromMap(DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data()!;
    return AccountPayable(
      id: doc.id, // Toma el ID directamente del documento de Firestore
      beneficiary: map['beneficiaryType'] == 'Supplier'
          ? Supplier.fromMap(map['beneficiary'])
          : Employee.fromMap(map['beneficiary']),
      dueDate: DateTime.parse(map['dueDate']),
      amount: map['amount'],
      isPaid: map['isPaid'],
    );
  }

  factory AccountPayable.fromDocument(DocumentSnapshot  doc) {
    final data = doc.data()  as Map<String, dynamic>;
    return AccountPayable(
      id: doc.id, // Asignar el ID del documento
      beneficiary: data['beneficiaryType'] == 'Supplier'
          ? Supplier.fromMap(data['beneficiary']) // Crear Supplier desde el map
          : Employee.fromMap(data['beneficiary']), // Crear Employee desde el map
      dueDate: DateTime.parse(data['dueDate']), // Parsear la fecha
      amount: (data['amount'] as num).toDouble(), 
      isPaid: data['isPaid'] ?? false, // Asignar estado de pago
    );
  }


  // Método para obtener la fecha formateada
  String get formattedDueDate {
    return DateFormat('yyyy-MM-dd').format(dueDate);
  }
}
