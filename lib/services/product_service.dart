import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prodtrack/models/product.dart';

class ProductService {
  final CollectionReference _productCollection = FirebaseFirestore.instance.collection('products');

   Future<void> addProduct(Product product) async {
    await _productCollection.add(product.toMap());
  }


  // Leer todos los productos
  Future<List<Product>> getAllProducts() async {
    QuerySnapshot snapshot = await _productCollection.get(); 
    return snapshot.docs.map((doc) {
      return Product.fromMap(doc.data() as Map<String, dynamic>)
        ..id = doc.id; 
    }).toList();

  }

  // Actualizar un producto
  Future<void> updateProduct(Product product) async {
    await _productCollection.doc(product.id).update(product.toMap());
  }
  Future<void> updateProductByQuuantity(String? id, int quantity) async {
    await _productCollection.doc(id).update({'quantity': quantity});
  }

  // Eliminar un producto
  Future<void> deleteProduct(String productId) async {
    await _productCollection.doc(productId).delete();
  }
}