import 'package:get/get.dart';
import 'package:prodtrack/models/sales_invoice.dart';
import 'package:prodtrack/services/sales_invoice_services.dart';

class SalesInvoiceController extends GetxController {
  final SalesInvoiceService _salesInvoiceService = SalesInvoiceService();

  // Lista de facturas observables
  RxList<SalesInvoice> salesInvoices = <SalesInvoice>[].obs;

  // Lista filtrada de facturas observables
  RxList<SalesInvoice> filteredSalesInvoices = <SalesInvoice>[].obs;

  // Estado de carga
  RxBool isLoading = false.obs;

  RxMap<DateTime, double> salesData = <DateTime, double>{}.obs; 

  @override
  void onInit() {
    super.onInit();
    fetchSalesInvoices();
  }

  // Obtener todas las facturas del servicio y actualizar las listas observables
void fetchSalesInvoices() async {
  try {
    isLoading.value = true;
    salesInvoices.value = await _salesInvoiceService.getAllSalesInvoices();
    salesInvoices.sort((a, b) => a.customer.compareTo(b.customer));
    filteredSalesInvoices.value = salesInvoices; 
    calculateSalesByDate(); 
  } catch (e) {
    Get.snackbar('Error', 'No se pudieron cargar las facturas');
  } finally {
    isLoading.value = false;
  }
}

  // Filtrar facturas por cliente
  void filterSalesInvoices(String query) {
    if (query.isEmpty) {
      filteredSalesInvoices.value = salesInvoices;
    } else {
      filteredSalesInvoices.value = salesInvoices.where((salesInvoice) {
        return salesInvoice.customer.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  // Agregar una nueva factura
  Future<void> addSalesInvoice(SalesInvoice salesInvoice) async {
    try {
      await _salesInvoiceService.saveSalesInvoice(salesInvoice);
      salesInvoices.add(salesInvoice);  // Añadir nueva factura a la lista actual
    } catch (e) {
      Get.snackbar('Error', 'No se pudo agregar la factura');
    }
  }

  // Actualizar una factura existente
  Future<void> updateSalesInvoice(SalesInvoice salesInvoice) async {
    try {
      await _salesInvoiceService.updateSalesInvoice(salesInvoice.id, salesInvoice);
      int index = salesInvoices.indexWhere((s) => s.id == salesInvoice.id);
      if (index != -1) {
        salesInvoices[index] = salesInvoice;  // Actualizar la factura en la lista
      }
    } catch (e) {
      Get.snackbar('Error', 'No se pudo actualizar la factura');
    }
  }

  // Eliminar una factura
  Future<void> deleteSalesInvoice(String salesInvoiceId) async {
    try {
      await _salesInvoiceService.deleteSalesInvoice(salesInvoiceId);
      salesInvoices.removeWhere((salesInvoice) => salesInvoice.id == salesInvoiceId);  // Eliminar de la lista actual
    } catch (e) {
      Get.snackbar('Error', 'No se pudo eliminar la factura');
    }
  }

  void calculateSalesByDate() {
    Map<DateTime, double> calculatedData = {};
    
    for (var invoice in filteredSalesInvoices) {
      final date = invoice.date;  // Suponiendo que 'date' es un campo de SalesInvoice
      final total = invoice.totalInvoice;  // Suponiendo que 'totalInvoice' es el monto total de la factura
      print("Total" + total.toString());
      if (calculatedData.containsKey(date)) {
        calculatedData[date] = calculatedData[date]! + total;
      } else {
        calculatedData[date] = total;
      }
    }
    
    salesData.value = calculatedData;  // Actualiza el salesData reactivo
  }
}
