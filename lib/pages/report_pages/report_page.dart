import 'package:flutter/material.dart';
import 'package:prodtrack/pages/report_pages/account_payable/accounts_payable.dart';
import 'package:prodtrack/pages/report_pages/price_product/price_product_report.dart';

class ReportPage extends StatelessWidget {
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
        body: const TabBarView(
          children: [
            Center(child: AccountsPayableView()),

            Center(child: Text('Informe de los gastos')),
            
            Center(child: PriceProductReport()),

            Center(child: Text('Informe de las ventas')),
          ],
        ),
      ),
    );
  }
}
