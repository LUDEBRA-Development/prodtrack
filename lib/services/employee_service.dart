import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prodtrack/models/user_model.dart';
class EmployeeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


// Obtener todos los empleados
  Future<List<UserModel>> getAllEmployees() async {
    try {
      // Filtra por los documentos donde el rol es 'empleado'
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('rol', isEqualTo: 'employee')
          .get();

      // Mapea los documentos a instancias de Employee
      return querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }






  // Eliminar un empleado
  Future<void> deleteEmployee(int employeeId) async {
    try {
      await _firestore.collection('employees').doc(employeeId.toString()).delete();
    } catch (e) {
      print("Error eliminando empleado: $e");
    }
  }
}
