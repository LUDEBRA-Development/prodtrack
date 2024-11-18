import 'package:flutter/material.dart';
import 'package:prodtrack/models/Ingredient.dart';
import 'package:prodtrack/models/product.dart';
import 'package:prodtrack/pages/index_pages.dart';
import 'package:prodtrack/services/ingredients_service.dart';
import 'package:prodtrack/services/product_service.dart';
import 'package:get/get.dart';

class ProductController extends GetxController{
  final ProductService _productService = ProductService();
  final IngredientsService _ingredientsService = IngredientsService();

  RxList<Product> product = <Product>[].obs;        
  RxList<Product> filteredProducts = <Product>[].obs;   
  RxList<Product> selectedProducts = <Product>[].obs;
  bool get isSelectionMode => selectedProducts.isNotEmpty;
  @override
  void onInit() {
    super.onInit();
    fetchProdcuts();  
  }

  void fetchProdcuts() async {
    product.value = await _productService.getAllProducts();
    product.sort((a, b) => b.name.compareTo(a.name));

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

Future<bool> updateQuantity(Product product, int quantityNew) async {
  try {
    List<Ingredient> ingredientsToUpdate = [];
    double _totalQuantityInput = product.totalQuantityInput;
    double ingredienteTotal;
    // Primero, verifica si todos los ingredientes tienen suficiente cantidad
    for (var ingredient in product.ingredients) {
      Ingredient? searchIngredient = await _ingredientsService.getIngredientById(ingredient.id.toString());
      if (searchIngredient == null) {
        Get.snackbar("Mensaje", "No se encontró el ingrediente ${ingredient.name}. La operación se cancelará");
        return false; 
      }
      double undProductIngredient = (ingredient.quantityUsed * product.packing.und.value) / _totalQuantityInput;     //Cantidad de insumo por capacidad de envase
      double boxProductIngredient = product.box.ability != null 
      ? undProductIngredient * product.box.ability! 
      : 0.0;

      ingredienteTotal = boxProductIngredient * quantityNew;
      ingredient.quantityUsed = ingredienteTotal / 1000;
      
      if (searchIngredient.quantityInInventory < ingredient.quantityUsed) {
        Get.snackbar("Error", "Ingrediente ${ingredient.name} : sno disponible en la cantidad necesaria. La operación se cancelará.");
        return false; // Salimos de la función si no hay suficiente cantidad
      }

      // Agregar el ingrediente a la lista temporal si cumple con la cantidad requerida
      ingredientsToUpdate.add(searchIngredient);
    }

    // Si todos los ingredientes están disponibles en cantidad suficiente, procedemos a actualizar
    for (var i = 0; i < ingredientsToUpdate.length; i++) {
      Ingredient ingredientToUpdate = ingredientsToUpdate[i];
      Ingredient productIngredient = product.ingredients[i];

      // Restamos la cantidad requerida
      ingredientToUpdate.quantityInInventory -= productIngredient.quantityUsed;
      
      // Actualizamos en la base de datos el ingrediente
      await _ingredientsService.updateIngredient(ingredientToUpdate);
    }
    
    quantityNew =quantityNew + product.quantity;
    await _productService.updateProductByQuuantity(product.id,quantityNew  );
    Get.snackbar("Mensaje", " ${product.name} se actualizo correctamente.");
    fetchProdcuts();
    return true;
  
  } catch (e){
    Get.snackbar("Mensaje", "Error al actualizar el producto. Intente de nuevo.");
    return false;
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
    Get.offAll(() => const indexPages());
  }

  void toggleSelection(Product product) {
    if (selectedProducts.contains(product)) {
      selectedProducts.remove(product);
    } else {
      selectedProducts.add(product);
    }
    selectedProducts.refresh(); // Notifica a los observadores
  }


  // Limpia todas las selecciones
  void clearSelection() {
    selectedProducts.clear();
  }

  void saveProductAmount(int productId, int amount) {
  final product = selectedProducts.firstWhere((product) => product.id == productId);
  product.quantity = amount;
  update(); // Actualiza la UI si es necesario
  }
}











