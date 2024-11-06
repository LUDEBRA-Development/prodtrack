import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prodtrack/models/Supplier.dart';

class SupplierService {
  final String supplierCollection = "suppliers";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveSupplier(Supplier supplier) async {
    DocumentReference docRef =
        await _firestore.collection(supplierCollection).add(supplier.toMap());
    supplier.id = docRef.id;
  }

  // Leer (Obtener) todos los proveedores
  Future<List<Supplier>> getAllSuppliers() async {
    QuerySnapshot snapshot = await _firestore.collection(supplierCollection).get();
    return snapshot.docs.map((doc) => Supplier.fromDocument(doc)).toList();
  }

  // Obtener un proveedor por ID
  Future<Supplier?> getSupplierById(String id) async {
    DocumentSnapshot doc =
        await _firestore.collection(supplierCollection).doc(id).get();
    if (doc.exists) {
      return Supplier.fromDocument(doc);
    }
    return null; // Si no existe, retornar null
  }

  // Buscar proveedores por nombre
  Future<List<Supplier>> searchSuppliersByName(String name) async {
    QuerySnapshot snapshot = await _firestore
        .collection(supplierCollection)
        .where('name', isEqualTo: name)
        .get();
    return snapshot.docs.map((doc) => Supplier.fromDocument(doc)).toList();
  }

  // Buscar proveedores por cualquier campo
  Future<List<Supplier>> searchSuppliers(String field, String value) async {
    QuerySnapshot snapshot = await _firestore
        .collection(supplierCollection)
        .where(field, isEqualTo: value)
        .get();
    return snapshot.docs.map((doc) => Supplier.fromDocument(doc)).toList();
  }

  // Actualizar un proveedor
  Future<void> updateSupplier(Supplier supplier) async {
    await _firestore
        .collection(supplierCollection)
        .doc(supplier.id)
        .update(supplier.toMap());
  }

  // Eliminar un proveedor
  Future<void> deleteSupplier(String id) async {
    await _firestore.collection(supplierCollection).doc(id).delete();
  }
}
