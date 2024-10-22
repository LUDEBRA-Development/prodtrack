import 'package:prodtrack/models/product.dart';
import 'package:prodtrack/services/product_service.dart';
import 'package:get/get.dart';

class ProductController extends GetxController{
  final ProductService _productService = ProductService();
  RxList<Product> notes = <Product>[].obs;        
  RxList<Product> filteredNotes = <Product>[].obs;   
  @override
  void onInit() {
    super.onInit();
    fetchProdcuts();  
  }

  void fetchProdcuts() async {
    notes.value = await _productService.getAllProducts();
    filteredNotes.value = notes; 
  }


  void filterProducts(String query) {
    if (query.isEmpty) {
      // Si el campo de búsqueda está vacío, mostrar todod profuctos
      filteredNotes.value = notes;
    } else {
      // Filtrar los productos
      filteredNotes.value = notes.where((note) {
        return note.name.toLowerCase().contains(query.toLowerCase()) ||
               note.description.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  // Agregar una nota a través del servicio
  Future<void> addProduct(Product product) async {
    await _productService.addProduct(product);
    fetchProdcuts(); 
  }

  // Actualizar una nota a través del servicio
  Future<void> updateProduct(Product product) async {
    await _productService.updateProduct(product);
    fetchProdcuts();  
  }

    // Eliminar una nota a través del servicio
  Future<void> deteleteProduct(String productId) async {
    await _productService.deleteProduct(productId);
    fetchProdcuts(); 
  }
}











