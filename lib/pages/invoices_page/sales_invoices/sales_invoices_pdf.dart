import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prodtrack/models/sales_invoice.dart'; // Para guardar el archivo en dispositivos móviles

class SalesInvoicePDF {
  final SalesInvoice salesInvoice;

  SalesInvoicePDF(this.salesInvoice);

  // Genera el PDF
  Future<void> generatePDF() async {
    final pdf = pw.Document();

    // Construye el contenido del PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("Factura de Venta", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Text("Cliente: ${salesInvoice.customer}"),
            pw.Text("Fecha de realización: ${salesInvoice.date}"),
            pw.SizedBox(height: 20),
            pw.Text("Productos:", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.ListView.builder(
              itemCount: salesInvoice.products.length,
              itemBuilder: (context, index) {
                final item = salesInvoice.products[index];
                return pw.Container(
                  padding: const pw.EdgeInsets.symmetric(vertical: 8),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Nombre: ${item.name}"),
                      pw.Text("Precio: \$${item.boxPrice}"),
                      pw.Text("Cantidad: ${item.quantity}"),
                      pw.Text("Total: \$${item.boxPrice * item.quantity}"),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );

    // Guardar y descargar el archivo PDF
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/factura_${salesInvoice.id}.pdf");
    await file.writeAsBytes(await pdf.save());
    await Printing.sharePdf(bytes: await pdf.save(), filename: "factura_${salesInvoice.id}.pdf");
  }
}
