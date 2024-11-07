import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prodtrack/controllers/sales_invoices_controller.dart';
import 'package:prodtrack/pages/invoices_page/sales_invoices/create_sales_invoices_page.dart';
import 'package:prodtrack/widgets/seach.dart';

class SalesInvoiceView extends StatefulWidget {
  const SalesInvoiceView({super.key});

  @override
  State<SalesInvoiceView> createState() => _SalesInvoiceViewState();
}

class _SalesInvoiceViewState extends State<SalesInvoiceView> {
  final SalesInvoiceController salesInvoiceController = Get.put(SalesInvoiceController()); // Controlador
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      salesInvoiceController.filterSalesInvoices(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFdcdcdc),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 40.0, right: 40.0),
            child: searchBar(_searchController, "Buscar facturas"),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 90.0, top: 10.0),
            child: addSalesInvoiceButton(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 40.0, right: 40.0),
              child: Obx(() {
                return ListView.builder(
                  itemCount: salesInvoiceController.filteredSalesInvoices.length,
                  itemBuilder: (BuildContext context, int index) {
                    final salesInvoice = salesInvoiceController.filteredSalesInvoices[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                      child: ListTile(
                        onTap: () {
                         /*  Get.to(() => ModifySalesInvoiceView(salesInvoice: salesInvoice)); */
                        },
                        title: Text(
                          salesInvoice.customer,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 35, fontFamily: "Regular"),
                        ),
                        subtitle: Text(
                          'Total: \$${salesInvoice.totalInvoice.toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 20, fontFamily: "Regular"),
                        ),
                        
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                          size: 20,
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

  Widget addSalesInvoiceButton() {
    return Container(
      color: const Color(0xFFdcdcdc),
      padding: const EdgeInsets.only(right: 5.0, top: 8.0, bottom: 8.0),
      child: ElevatedButton(
        onPressed: () {
          Get.to(() => const  CreateSalesInvoicesPage());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFdcdcdc),
          elevation: 0,
        ),
        child:  Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 68, 109, 199),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: const Icon(
                Icons.add_sharp,
                color: Colors.white,
                size: 48,
              ),
            ),
            const SizedBox(width: 30),
            const Text(
              "Añadir Factura",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget avatar(String customerName) {
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

    // Obtener la letra inicial y convertirla a mayúscula
    String firstLetter = customerName.isNotEmpty ? customerName[0].toUpperCase() : 'A';

    // Calcular el índice basado en la letra inicial (A=0, B=1, ..., Z=25)
    int colorIndex =
        (firstLetter.codeUnitAt(0) - 'A'.codeUnitAt(0)) % colors.length;

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
}
