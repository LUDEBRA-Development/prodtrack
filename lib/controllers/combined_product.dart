import 'package:prodtrack/models/Ingredient.dart';
import 'package:prodtrack/models/product.dart';
import 'package:prodtrack/services/ingredients_service.dart';
import 'package:prodtrack/services/product_service.dart';
import 'package:get/get.dart';

class CombinedProductController extends GetxController{
  final ProductService _productService = ProductService();
  final IngredientsService _ingredientsService = IngredientsService();

  RxList<Product> product = <Product>[].obs;        
  final RxList<Product> filteredProducts = <Product>[].obs;   
  final RxList<Ingredient> _ingredient = <Ingredient>[].obs;        
  final RxList<Ingredient> filteredIngredients = <Ingredient>[].obs;   

  RxList<dynamic> filteredcombinedData = <dynamic>[].obs;   
  RxList<dynamic> combinedData = <dynamic>[].obs;   

  @override
  void onInit() {
    super.onInit();
    _fetchProducts();  
    _fetchIngredients();  
  }

  void _fetchProducts() async {
    product.value = await _productService.getAllProducts();
    filteredProducts.value = product; 
    _fetchCombinedData(); // Asegúrate de llamar a este método después de obtener los productos.
  }

  void _fetchIngredients() async {
    _ingredient.value = await _ingredientsService.getAllIngredients();
    filteredIngredients.value = _ingredient; 
    _fetchCombinedData(); // Asegúrate de llamar a este método después de obtener los ingredientes.
  }

  void _fetchCombinedData() {
    
    combinedData.value = [...filteredProducts, ...filteredIngredients];

    combinedData.value.sort((a, b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    filteredcombinedData.value = combinedData;
  }

  void filterProductsCombinedData(String query) {
    if (query.isEmpty) {
      filteredcombinedData.value = combinedData;
    } else {
      filteredcombinedData.value = [
        ...product.where((note) {
          return note.name.toLowerCase().contains(query.toLowerCase()) ||
                 note.description.toLowerCase().contains(query.toLowerCase());
        }),
        ..._ingredient.where((ingredient) {
          return ingredient.name.toLowerCase().contains(query.toLowerCase());
        }),
      ];
    }
  }

  void filterProductsForType(String query, {String? status}) {
    if (status == 'Todos' || status == null) {
      // Si el estado es "Todos", mostramos tanto productos como ingredientes
      filteredcombinedData.value = [
        ...product.where((note) {
          return note.name.toLowerCase().contains(query.toLowerCase()) ||
                note.description.toLowerCase().contains(query.toLowerCase());
        }),
        ..._ingredient.where((ingredient) {
          return ingredient.name.toLowerCase().contains(query.toLowerCase());
        }),
      ];
      filteredcombinedData.value.sort((a, b) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
    } else if (status == 'Fabricados') {
      // Si el estado es "Productos", mostramos solo productos
      filteredcombinedData.value = [
        ...product.where((note) {
          return note.name.toLowerCase().contains(query.toLowerCase()) ||
                note.description.toLowerCase().contains(query.toLowerCase());
        }),
      ];
      filteredcombinedData.value.sort((a, b) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
    } else if (status == 'Insumos') {
      // Si el estado es "Ingredientes", mostramos solo ingredientes
      filteredcombinedData.value = [
        ..._ingredient.where((ingredient) {
          return ingredient.name.toLowerCase().contains(query.toLowerCase());
        }),
      ];
      filteredcombinedData.value.sort((a, b) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
    }
  }


}











