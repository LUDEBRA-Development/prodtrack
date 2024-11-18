import 'package:get/get.dart';
import 'package:prodtrack/models/Supplier.dart';
import 'package:prodtrack/services/supplier_service.dart';

class SupplierController extends GetxController {
  final SupplierService _supplierService = SupplierService();
  
  // Lista de proveedores observables
  RxList<Supplier> suppliers = <Supplier>[].obs;
  
  // Lista filtrada de proveedores observables
  RxList<Supplier> filteredSuppliers = <Supplier>[].obs;

  // Estado de carga
  RxBool isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchSuppliers();  // Cargar proveedores al inicializar el controlador
  }

  // Obtener todos los proveedores del servicio y actualizar las listas observables
  void fetchSuppliers() async {
    try {
      isLoading.value = true;
      suppliers.value = await _supplierService.getAllSuppliers();
      suppliers.sort((a, b)=> b.name.compareTo(a.name));
      filteredSuppliers.value = suppliers; // Mostrar todos los proveedores al inicio
    } catch (e) {
      Get.snackbar('Error', 'No se pudieron cargar los proveedores');
    } finally {
      isLoading.value = false;
    }
  }

  // Filtrar proveedores por nombre o teléfono
  void filterSuppliers(String query) {
    if (query.isEmpty) {
      filteredSuppliers.value = suppliers;
    } else {
      filteredSuppliers.value = suppliers.where((supplier) {
        return supplier.name.toLowerCase().contains(query.toLowerCase()) ||
               supplier.phone.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  // Agregar un proveedor
  Future<void> addSupplier(Supplier supplier) async {
    try {
      await _supplierService.saveSupplier(supplier);
      suppliers.add(supplier);  // Añadir nuevo proveedor a la lista actual
    } catch (e) {
      Get.snackbar('Error', 'No se pudo agregar el proveedor');
    }
  }

  // Actualizar un proveedor
  Future<void> updateSupplier(Supplier supplier) async {

      await _supplierService.updateSupplier(supplier);
      int index = suppliers.indexWhere((s) => s.id == supplier.id);
      if (index != -1) {
        suppliers[index] = supplier;  
      }

  }

  // Eliminar un proveedor
  Future<void> deleteSupplier(String supplierId) async {
    try {
      await _supplierService.deleteSupplier(supplierId);
      suppliers.removeWhere((supplier) => supplier.id == supplierId);  // Eliminar de la lista actual
    } catch (e) {
      Get.snackbar('Error', 'No se pudo eliminar el proveedor');
    }
  }
}
