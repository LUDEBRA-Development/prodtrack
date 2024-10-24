import 'package:prodtrack/models/product.dart';
import 'package:prodtrack/services/product_service.dart';
import 'package:get/get.dart';

class ProductController extends GetxController{
  final ProductService _productService = ProductService();
  RxList<Product> product = <Product>[].obs;        
  RxList<Product> filteredProducts = <Product>[].obs;   
  @override
  void onInit() {
    super.onInit();
    fetchProdcuts();  
  }

  void fetchProdcuts() async {
    product.value = await _productService.getAllProducts();
    filteredProducts.value = product; 
  }


  void filterProducts(String query) {
    if (query.isEmpty) {
      
      filteredProducts.value = product;
    } else {
      
      filteredProducts.value = product.where((note) {
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











