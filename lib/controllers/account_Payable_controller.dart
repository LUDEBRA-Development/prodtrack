import 'package:get/get.dart';
import 'package:prodtrack/models/account_payable.dart';
import 'package:prodtrack/services/acount_payable_service.dart';
class AccountPayableController extends GetxController {
  final AccountPayableService accountPayableService = AccountPayableService();
  
  // Lista de cuentas por pagar observables
  RxList<AccountPayable> accountsPayable = <AccountPayable>[].obs;
  
  // Lista filtrada de cuentas por pagar observables
  RxList<AccountPayable> filteredAccountsPayable = <AccountPayable>[].obs;

  // Estado de carga
  RxBool isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchAccountsPayable();  // Cargar cuentas por pagar al inicializar el controlador
  }

  // Obtener todas las cuentas por pagar del servicio y actualizar las listas observables
  void fetchAccountsPayable() async {
    try {
      isLoading.value = true;
      accountsPayable.value = await accountPayableService.getAllAccountPayables();
      accountsPayable.sort((a, b) => a.beneficiary.name.compareTo(b.beneficiary.name));
      filteredAccountsPayable.value = accountsPayable;
    } catch (e) {
      Get.snackbar('Error', 'No se pudieron cargar las cuentas por pagar');
    } finally {
      isLoading.value = false;
    }
  }

  // Filtrar cuentas por pagar por beneficiario o fecha de vencimiento
  void filterAccountsPayable(String query) {
    if (query.isEmpty) {
      filteredAccountsPayable.value = accountsPayable;
    } else {
      filteredAccountsPayable.value = accountsPayable.where((account) {
        final beneficiaryName = account.beneficiary.name?.toLowerCase() ?? '';
        final dueDateString = account.dueDate.toString();
        return beneficiaryName.contains(query.toLowerCase()) ||
               dueDateString.contains(query);
      }).toList();
    }
  }

  // Agregar una cuenta por pagar
  Future<void> addAccountPayable(AccountPayable accountPayable) async {
    try {
      await accountPayableService.saveAccountPayable(accountPayable);
      accountsPayable.add(accountPayable);  // Añadir nueva cuenta a la lista actual
      filteredAccountsPayable.add(accountPayable);  // Actualizar también la lista filtrada
    } catch (e) {
      Get.snackbar('Error', 'No se pudo agregar la cuenta por pagar');
    }
    fetchAccountsPayable();

  }

  // Actualizar una cuenta por pagar
  Future<void> updateAccountPayable(AccountPayable accountPayable) async {
    try {
      await accountPayableService.updateAccountPayable(accountPayable);
      int index = accountsPayable.indexWhere((a) => a.id == accountPayable.id);
      if (index != -1) {
        accountsPayable[index] = accountPayable;  // Actualizar cuenta en la lista
        filteredAccountsPayable[index] = accountPayable;  // Actualizar también en la lista filtrada
      }
    } catch (e) {
      Get.snackbar('Error', 'No se pudo actualizar la cuenta por pagar');
    }
    fetchAccountsPayable();
  }

  // Eliminar una cuenta por pagar
  Future<void> deleteAccountPayable(String accountId) async {
    try {
      await accountPayableService.deleteAccountPayable(accountId.toString());
      accountsPayable.removeWhere((account) => account.id == accountId); 
      filteredAccountsPayable.removeWhere((account) => account.id == accountId);  
    } catch (e) {
      Get.snackbar('Error', 'No se pudo eliminar la cuenta por pagar');
    }
    fetchAccountsPayable();
  }

void filterAccountsPayableForStatus(String query, {String? status}) {
  filteredAccountsPayable.value = accountsPayable.where((account) {
    final beneficiaryName = account.beneficiary.name?.toLowerCase() ?? '';
    final dueDateString = account.dueDate.toString();
    final matchesSearch = beneficiaryName.contains(query.toLowerCase()) ||
                          dueDateString.contains(query);

    if (status != null && status != 'Todos') {
      bool isPaid = status == 'Pagados';
      return matchesSearch && account.isPaid == isPaid;
    }

    return matchesSearch;  
  }).toList();
}

}
