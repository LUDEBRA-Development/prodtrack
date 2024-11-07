import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prodtrack/models/sales_invoice.dart';

class SalesInvoiceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para guardar la factura en Firebase
  Future<String> saveSalesInvoice(SalesInvoice salesInvoice) async {
    try {
      // Agregar la factura a la colección "SalesInvoices" en Firestore
      DocumentReference docRef = await _firestore.collection('SalesInvoices').add(salesInvoice.toMap());
      return docRef.id;  // Retornar el ID del documento recién creado
    } catch (e) {
      throw Exception("Error al guardar la factura: $e");
    }
  }

  // Método para obtener una factura específica de Firebase usando el ID
  Future<SalesInvoice?> getSalesInvoice(String salesInvoiceId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('SalesInvoices').doc(salesInvoiceId).get();
      if (doc.exists) {
        return SalesInvoice.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception("Error al recuperar la factura: $e");
    }
  }

  // Método para obtener todas las facturas de Firebase
  Future<List<SalesInvoice>> getAllSalesInvoices() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('SalesInvoices').get();
      List<SalesInvoice> salesInvoices = snapshot.docs.map((doc) {
        return SalesInvoice.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      return salesInvoices;
    } catch (e) {
      throw Exception("Error al recuperar todas las facturas: $e");
    }
  }

  // Método para actualizar una factura en Firebase
  Future<void> updateSalesInvoice(String? salesInvoiceId, SalesInvoice updatedSalesInvoice) async {
    try {
      await _firestore.collection('SalesInvoices').doc(salesInvoiceId).update(updatedSalesInvoice.toMap());
    } catch (e) {
      throw Exception("Error al actualizar la factura: $e");
    }
  }

  // Método para eliminar una factura de Firebase
  Future<void> deleteSalesInvoice(String? salesInvoiceId) async {
    try {
      await _firestore.collection('SalesInvoices').doc(salesInvoiceId).delete();
    } catch (e) {
      throw Exception("Error al eliminar la factura: $e");
    }
  }
}

