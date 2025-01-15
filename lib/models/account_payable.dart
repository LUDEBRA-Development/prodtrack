import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prodtrack/models/Activity.dart';
import 'package:prodtrack/models/Supplier.dart';
import 'package:intl/intl.dart';
import 'package:prodtrack/models/user_model.dart';

class AccountPayable {
  String? id; // ID de Firestore
  final dynamic beneficiary; // Puede ser Supplier o Employee
  List<Activity> activity; // Lista de actividades
  final DateTime dueDate;
  final double amount;
  bool isPaid;

  AccountPayable({
    this.id, // La ID es opcional y puede asignarse después
    required this.beneficiary,
    required this.activity,
    required this.dueDate,
    required this.amount,
    this.isPaid = false,
  });

  // Método para convertir la clase a un formato Map (JSON) para Firestore
  Map<String, dynamic> toMap() {
    return {
      'beneficiaryType': beneficiary is Supplier ? 'Supplier' : 'Employee',
      'beneficiary': beneficiary is Supplier
          ? (beneficiary as Supplier).toMapAccount()
          : (beneficiary as UserModel).toMapAccount(),
      'activity': activity.map((a) => a.toMap()).toList(), // Convertir cada actividad a un mapa
      'dueDate': dueDate.toIso8601String(),
      'amount': amount,
      'isPaid': isPaid,
    };
  }

  // Método estático para crear una instancia desde un Map (Firestore snapshot)
  factory AccountPayable.fromMap(DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data()!;
    return AccountPayable(
      id: doc.id,
      beneficiary: map['beneficiaryType'] == 'Supplier'
          ? Supplier.fromMap(map['beneficiary'])
          : UserModel.fromMap(map['beneficiary']),
      activity: (map['activity'] as List<dynamic>)
          .map((a) => Activity.fromMap(a as Map<String, dynamic>))
          .toList(), // Convertir cada mapa en una instancia de Activity
      dueDate: DateTime.parse(map['dueDate']),
      amount: (map['amount'] as num).toDouble(),
      isPaid: map['isPaid'] ?? false,
    );
  }

  // Método estático para crear una instancia desde un DocumentSnapshot
  factory AccountPayable.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AccountPayable(
      id: doc.id,
      beneficiary: data['beneficiaryType'] == 'Supplier'
          ? Supplier.fromMap(data['beneficiary'])
          : UserModel.fromMap(data['beneficiary']),
      activity: (data['activity'] as List<dynamic>)
          .map((a) => Activity.fromMap(a as Map<String, dynamic>))
          .toList(), // Convertir cada mapa en una instancia de Activity
      dueDate: DateTime.parse(data['dueDate']),
      amount: (data['amount'] as num).toDouble(),
      isPaid: data['isPaid'] ?? false,
    );
  }

  // Método para obtener la fecha formateada
  String get formattedDueDate {
    return DateFormat('yyyy-MM-dd').format(dueDate);
  }
}
