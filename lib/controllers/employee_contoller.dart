import 'package:get/get.dart';
import 'package:prodtrack/models/user_model.dart';
import 'package:prodtrack/services/employee_service.dart';

class EmployeeController extends GetxController {
  final EmployeeService _employeeService = EmployeeService();
  
  // Lista de empleados observables
  RxList<UserModel> employees = <UserModel>[].obs;
    // Lista filtrada de proveedores observables
  RxList<UserModel> filteredEmployees = <UserModel>[].obs;

  // Estado de carga
  RxBool isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchEmployees();  // Cargar empleados al inicializar el controlador
  }

  // Obtener todos los empleados del servicio y actualizar la lista observable
void fetchEmployees() async {
  try {
    isLoading.value = true;
    // Obtener los empleados y ordenarlos alfabéticamente por nombre
    var allEmployees = await _employeeService.getAllEmployees();
    allEmployees.sort((a, b) => a.name.compareTo(b.name)); // Asumiendo que `name` es el campo para ordenar
    employees.value = allEmployees;
  } catch (e) {
    Get.snackbar('Error', 'No se pudieron cargar los empleados');
  } finally {
    isLoading.value = false;
  }
}


  void filterEmployee(String query) {
    if (query.isEmpty) {
      filteredEmployees.value = employees;
    } else {
      filteredEmployees.value = employees.where((Employee) {
        return Employee.name.toLowerCase().contains(query.toLowerCase()) ||
            Employee.id.toString().contains(query.toLowerCase());
      }).toList();
    }
  }
  // Agregar un empleado




  // Eliminar un empleado
  Future<void> deleteEmployee(int employeeId) async {
    try {
      await _employeeService.deleteEmployee(employeeId);
      employees.removeWhere((employee) => employee.id == employeeId);  // Eliminar de la lista actual
    } catch (e) {
      Get.snackbar('Error', 'No se pudo eliminar el empleado');
    }
  }
}
