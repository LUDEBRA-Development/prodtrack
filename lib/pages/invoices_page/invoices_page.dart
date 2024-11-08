import 'package:flutter/material.dart';
import 'package:prodtrack/pages/invoices_page/sales_invoices/sales_invoices_page.dart';


class InvoicesPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Número de pestañas
      child: Scaffold(
        appBar:AppBar(
          title:const  Text("Facturas"),
          backgroundColor: Colors.white,
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(40.0), // Ajusta la altura de la TabBar
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0), // Espacio adicional en la parte inferior
              child: TabBar(
                tabs: [
                  Tab(text: 'Vender'),
                  Tab(text: 'Comprar'),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: SalesInvoiceView()),
            
            Center(child: Text("Facturas de comprar")),

          ],
        ),
      ),
    );
  }
}
