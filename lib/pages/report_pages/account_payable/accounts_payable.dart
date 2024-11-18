import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prodtrack/controllers/account_Payable_controller.dart';
import 'package:prodtrack/models/account_payable.dart';
import 'package:prodtrack/pages/report_pages/account_payable/ModifyAccountPayableView.dart';
import 'package:prodtrack/widgets/avatar.dart';
import 'package:prodtrack/widgets/seach.dart';

class AccountsPayableView extends StatefulWidget {
  const AccountsPayableView({super.key});

  @override
  _AccountsPayableViewState createState() => _AccountsPayableViewState();
}

class _AccountsPayableViewState extends State<AccountsPayableView> {
  final AccountPayableController accountPayableController = Get.put(AccountPayableController());
  final TextEditingController _searchController = TextEditingController();
  
  // Estado seleccionado usando Rx para actualizar la UI automáticamente
  var selectedStatus = 'Todos'.obs; 

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      accountPayableController.filterAccountsPayable(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 241, 241),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 8.0, top: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: searchBar(_searchController, "Buscar"),
            ),

            const SizedBox(height: 10),
            filterAccountsPayableSelector(),
            
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Obx(() {
                  return ListView.builder(
                    itemCount: accountPayableController.filteredAccountsPayable.length,
                    itemBuilder: (BuildContext context, int index) {
                      final  account = accountPayableController.filteredAccountsPayable[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: ListTile(
                          onTap: () {
                            Get.to(()=> ModifyAccountPayableView(account : account))  ;
                          },
                          title: Text(
                            '${account.beneficiary.name} ',
                            style: const TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Fecha: ${account.formattedDueDate}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                account.isPaid ? "Pagado" : "Pendiente",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: account.isPaid ? Colors.green : Colors.red,
                                ),
                              ),
                            ],
                          ),
                          leading: imageProfile(account),
                          trailing: Text(
                            '\$${account.amount.toStringAsFixed(2).replaceAllMapped(
                              RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
                              (Match m) => '${m[1]},',
                            )}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: account.isPaid ? Colors.green : Colors.red,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget imageProfile(AccountPayable account) {
    return Image.network(
       account.beneficiary.urlProfilePhoto,
       loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
         if (loadingProgress == null) {
           return child;
         } else {
           return Center(
             child: CircularProgressIndicator(
               value: loadingProgress.expectedTotalBytes != null
                   ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                   : null,
             ),
           );
         }
       },
       errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
         return avatar(account.beneficiary.name);
       },
     );
  }

  Widget filterAccountsPayableSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        filterButton('Todos'),
        const SizedBox(width: 10),
        filterButton('Pagados'),
        const SizedBox(width: 10),
        filterButton('Pendientes'),
      ],
    );
  }

  Widget filterButton(String status) {
    return TextButton(
      onPressed: () {
        selectedStatus.value = status; // Cambiar el estado
        accountPayableController.filterAccountsPayableForStatus(
          _searchController.text,
          status: selectedStatus.value,
        );
      },
      child: Obx(() {
        return Text(
          status,
          style: TextStyle(
            color: selectedStatus.value == status ? Colors.blue : Colors.black,
          ),
        );
      }),
    );
  }
}
