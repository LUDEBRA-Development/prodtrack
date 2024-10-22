import 'package:get/get.dart';
import 'package:prodtrack/models/Ingredient.dart';
import 'package:prodtrack/services/ingredients_service.dart';

class IngredientsController extends GetxController {
  final IngredientsService _ingredientService = IngredientsService();

  // Lista de proveedores observables
  RxList<Ingredient> ingredients = <Ingredient>[].obs;

  // Lista filtrada de proveedores observables
  RxList<Ingredient> filteredIngredients = <Ingredient>[].obs;

  // Estado de carga
  RxBool isLoading = false.obs;

  // Variable para llevar el control del último ID
  RxInt _nextId = 0.obs; // Asegúrate de que _nextId sea un entero

  @override
  void onInit() {
    super.onInit();
    fetchIngredients(); // Cargar ingredientes al inicializar el controlador
  }

  // Obtener todos los ingredientes del servicio y actualizar las listas observables
  void fetchIngredients() async {
    // try {
    //   isLoading.value = true;
    //   ingredients.value = await _ingredientService.getAllIngredients();
    //   // Obtener el último ID existente para continuar desde ahí
    //   if (ingredients.isNotEmpty) {
    //     _nextId.value =
    //         int.parse(ingredients.last.id!) + 1; // Esto suma 1 al id numérico
    //   }
    //   filteredIngredients.value =
    //       ingredients; // Mostrar todos los ingredientes al inicio
    // } catch (e) {
    //   Get.snackbar('Error', 'No se pudieron cargar los ingredientes');
    // } finally {
    //   isLoading.value = false;
    // }

    ingredients.value = await _ingredientService
        .getAllIngredients(); // Obtener todos los ingredientes
    filteredIngredients.value = ingredients; // Actualizar la lista filtrada
  }

  // Filtrar ingredientes por nombre o precio
  void filterIngredients(String query) {
    if (query.isEmpty) {
      filteredIngredients.value = ingredients;
    } else {
      filteredIngredients.value = ingredients.where((ingredient) {
        return ingredient.name.toLowerCase().contains(query.toLowerCase()) ||
            ingredient.price.toString().contains(query.toLowerCase());
      }).toList();
    }
  }

  // Agregar un ingrediente con ID autoincrementable
  Future<void> addIngredient(Ingredient ingredient) async {
    try {
      // Asignar el ID autoincrementable
      ingredient.id = _nextId.value
          .toString(); // Convertir _nextId de int a String antes de asignarlo a ingredient.id
      _nextId.value =
          _nextId.value + 1; // Esto es equivalente a _nextId.value++

      await _ingredientService.saveIngredient(ingredient);
      ingredients.add(ingredient); // Añadir nuevo ingrediente a la lista actual
    } catch (e) {
      Get.snackbar('Error', 'No se pudo agregar el ingrediente');
    }
  }

  // Actualizar un ingrediente
  Future<void> updateIngredient(Ingredient ingredient) async {
    await _ingredientService.updateIngredient(ingredient);
    int index = ingredients.indexWhere((s) => s.id == ingredient.id);
    if (index != -1) {
      ingredients[index] = ingredient;
    }
  }

  // Eliminar un ingrediente
  Future<void> deleteIngredient(String ingredientId) async {
    try {
      await _ingredientService.deleteIngredient(ingredientId);
      ingredients.removeWhere((ingredient) =>
          ingredient.id == ingredientId); // Eliminar de la lista actual
    } catch (e) {
      Get.snackbar('Error', 'No se pudo eliminar el ingrediente');
    }
  }
}
