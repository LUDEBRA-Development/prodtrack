import 'package:flutter/material.dart';
import 'package:prodtrack/pages/report_pages/account_payable/accounts_payable.dart';
import 'package:prodtrack/pages/report_pages/price_product/price_product_report.dart';
import 'package:prodtrack/pages/report_pages/sales/sales_chart.dart';
import 'package:get/get.dart';
import 'package:prodtrack/controllers/sales_invoices_controller.dart';

class ReportPage extends StatelessWidget {
     final SalesInvoiceController salesInvoiceController = Get.put(SalesInvoiceController());
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Número de pestañas
      child: Scaffold(
        appBar:AppBar(
          backgroundColor: Colors.white,
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(5.0), // Ajusta la altura de la TabBar
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0), // Espacio adicional en la parte inferior
              child: TabBar(
                tabs: [
                  Tab(text: 'Cuentas'),
                  Tab(text: 'Gastos'),
                  Tab(text: 'Precios'),
                  Tab(text: 'Ventas'),
                ],
              ),
            ),
          ),
        ),
        body:  TabBarView(
          children: [
            const Center(child: AccountsPayableView()),

            const Center(child: Text('Informe de los gastos')),
            
            const Center(child: PriceProductReport()),

            Center(child: SalesChart()),
          ],
        ),
      ),
    );
  }
}
