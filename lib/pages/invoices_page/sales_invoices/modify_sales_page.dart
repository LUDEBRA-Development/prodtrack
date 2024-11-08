import 'package:flutter/material.dart';
import 'package:prodtrack/controllers/sales_invoices_controller.dart';
import 'package:prodtrack/models/sales_invoice.dart';
import 'package:get/get.dart';
import 'package:prodtrack/pages/invoices_page/sales_invoices/sales_invoices_pdf.dart';
import 'package:prodtrack/widgets/format_with_commas.dart';

class ModifySalesInvoiceView extends StatelessWidget {
  final SalesInvoice salesInvoice;
  final SalesInvoiceController salesInvoiceController = Get.put(SalesInvoiceController()); // Controlador
  ModifySalesInvoiceView({super.key, required this.salesInvoice});
  

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualizar factura', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.teal,
        elevation: 0, 
        
      ),
      backgroundColor: Colors.grey[200], // Fondo suave
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(12.0),
                boxShadow:const  [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildText("Cliente", salesInvoice.customer),
                  const Divider(), // Línea divisoria
                  buildText("Fecha de realización", salesInvoice.date.toString()),
                ],
              ),
            ),
            listWidgetproduct(),
            totalFacturaWidget(),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  // Acción para descargar o compartir
                  SalesInvoicePDF pdfGenerator = SalesInvoicePDF(salesInvoice);
                  await pdfGenerator.generatePDF();
                },
                icon: const Icon(Icons.download_rounded, color: Colors.white,),
                label: const Text('Descargar factura', style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor:const  Color(0xFFec1074), // Color del botón
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildText(String name, String data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 4), 
          Text(
            data,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget listWidgetproduct() {

    if (salesInvoice.products == null || salesInvoice.products.isEmpty) {
      return const Padding(
        padding:  EdgeInsets.all(16.0),
        child:  Text(
          "No hay productos para mostrar.",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return Column(
      children: salesInvoice.products.map((item) {
        return Card(
          color: Colors.white, 
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.black,
                    ),
                  ),
                ),
               
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      const Icon(Icons.attach_money, size: 16),
                      Text(
                        "Precio: \$${formatWithCommas(item.boxPrice)}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      const Icon(Icons.shopping_cart, size: 16),
                      Text(
                        "Cantidad: ${item.quantity}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
               
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      const Icon(Icons.payment, size: 16),
                      Text(
                        "Total: \$${formatWithCommas((item.quantity * item.boxPrice).toDouble())}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget totalFacturaWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Espaciado
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end, // Alinea el texto a la derecha
        children: [
          const Text(
            "Total",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 33, 243, 79), // Puedes elegir el color que desees
            ),
          ),
          Text(": \$${formatWithCommas(salesInvoice.totalInvoice)}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

