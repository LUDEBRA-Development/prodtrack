import 'package:prodtrack/models/sales_invoice.dart';



Future<Map<DateTime, double>> calculateSalesByDate(List<SalesInvoice> invoices) async {
  final Map<DateTime, double> salesData = {};
  for (var invoice in invoices) {
    DateTime date = DateTime(invoice.date.year, invoice.date.month, invoice.date.day);
    salesData.update(date, (value) => value + invoice.totalInvoice, ifAbsent: () => invoice.totalInvoice);
  }
  return salesData;
}


