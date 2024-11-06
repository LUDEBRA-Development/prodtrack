import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prodtrack/models/employee.dart';
class EmployeeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtener todos los empleados
  Future<List<Employee>> getAllEmployees() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('employees').get();
      return querySnapshot.docs.map((doc) => Employee.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      print("Error obteniendo empleados: $e");
      return [];
    }
  }

  // Agregar un empleado
  Future<void> saveEmployee(Employee employee) async {
    try {
      await _firestore.collection('employees').add(employee.toMap());
    } catch (e) {
      print("Error agregando empleado: $e");
    }
  }

  // Actualizar un empleado
  Future<void> updateEmployee(Employee employee) async {
    try {
      await _firestore.collection('employees').doc(employee.id.toString()).update(employee.toMap());
    } catch (e) {
      print("Error actualizando empleado: $e");
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
