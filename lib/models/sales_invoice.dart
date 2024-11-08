import 'package:prodtrack/models/product.dart';

class SalesInvoice {
  String? id; // Este es el ID de la factura
  String customer;
  DateTime date;
  List<Product> products;
  double totalInvoice;

  SalesInvoice({
     this.id, // Ahora necesitas el ID al crear la factura
    required this.customer,
    required this.date,
    required this.products,
  }) : totalInvoice = products.fold(
          0, (sum, product) => sum + (product.boxPrice * product.quantity),
        );

  // Convert invoice to map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer': customer,
      'date': date.toIso8601String(),
      'products': products.map((product) => product.toMap()).toList(),
      'totalInvoice': totalInvoice,
    };
  }

  // Convert a map to an invoice (for reading from Firestore)
  static SalesInvoice fromMap(Map<String, dynamic> map) {
    return SalesInvoice(
      id: map['id'],
      customer: map['customer'],
      date: DateTime.parse(map['date']),
      products: List<Product>.from(map['products']?.map((x) => Product.fromMap(x))),
    );
  }
}
