import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prodtrack/controllers/account_Payable_controller.dart';
import 'package:prodtrack/models/account_payable.dart';
import 'package:prodtrack/pages/report_pages/account_payable/ModifyAccountPayableView.dart';
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
      backgroundColor: const Color(0xFFdcdcdc),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
          backgroundColor: const Color(0xFFdcdcdc),
          title: const Center(
            child:  Text(
              "Cuentas por Pagar",
              style: TextStyle(color: Colors.black, fontSize: 34, height: 20),
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: searchBar(_searchController, "Buscar"),
          ),
          const SizedBox(height: 10),
          
          // Filtrar por estado usando botones
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
                          // Aquí podrías redirigir a una vista para modificar la cuenta por pagar
                          // Get.to(() => ModifyAccountPayableView(account: account));
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
    );
  }

  Widget avatar(String name) {
    List<String> colors = [
      "F56217",
      "F5CC17",
      "00875E",
      "04394E",
      "9C27B0",
      "E91E63",
      "3F51B5",
      "4CAF50",
    ];

    Color getColorFromHex(String hexColor) {
      final hexCode = hexColor.replaceAll("#", "");
      return Color(int.parse("FF$hexCode", radix: 16));
    }

    String firstLetter = name.isNotEmpty ? name[0].toUpperCase() : 'A';
    int colorIndex = (firstLetter.codeUnitAt(0) - 'A'.codeUnitAt(0)) % colors.length;

    return CircleAvatar(
      backgroundColor: getColorFromHex(colors[colorIndex]),
      radius: 30,
      child: Text(
        firstLetter,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32,
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
