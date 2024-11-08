import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prodtrack/controllers/ingredients_controller.dart';
import 'package:prodtrack/models/Ingredient.dart';
import 'package:prodtrack/pages/ingredients_page/add_ingredient_page.dart';
import 'package:prodtrack/pages/ingredients_page/modify_ingredient_page.dart';

class IngredientsPage extends StatefulWidget {
  IngredientsPage({super.key});

  @override
  State<IngredientsPage> createState() => _IngredientPageState();
}

class _IngredientPageState extends State<IngredientsPage> {
  final IngredientsController ingredientController =
      Get.put(IngredientsController()); // Controlador

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      ingredientController.filterIngredients(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFdcdcdc),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
            child: searchBar(),
          ),
          Center(
            child: addIngredientButton(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Obx(() {
                if (ingredientController.filteredIngredients.isEmpty) {
                  return const Center(
                    child: Text("No hay ingredientes disponibles."),
                  );
                } else {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Cards por fila
                      childAspectRatio:
                          0.75, // Relación de aspecto para achicar
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: ingredientController.filteredIngredients.length,
                    itemBuilder: (BuildContext context, int index) {
                      final ingredient =
                          ingredientController.filteredIngredients[index];
                      return ingredientCard(ingredient);
                    },
                  );
                }
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchBar() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFcbcbcb),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.black),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 8),
          hintText: "Buscar Ingrediente",
          hintStyle: TextStyle(color: Color(0xFF787878), fontSize: 17),
          border: InputBorder.none,
          icon: Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Icon(Icons.search, color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget addIngredientButton() {
    return Container(
      color: const Color(0xFFdcdcdc),
      padding: const EdgeInsets.only(right: 5.0, top: 8.0, bottom: 8.0),
      child: ElevatedButton(
        onPressed: () {
          Get.to(() => const CreateIngredientView());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFdcdcdc),
          elevation: 0,
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.blender_rounded,
              color: Color.fromRGBO(0, 0, 0, 1),
              size: 48,
            ),
            SizedBox(width: 30),
            Text(
              "Añadir Ingrediente",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget ingredientCard(Ingredient ingredient) {
    return GestureDetector(
      onTap: () {
        Get.to(ModifyIngredientView(ingredient: ingredient));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        child: Column(
          children: [
            // Parte superior con color e inicial
            Container(
              decoration: BoxDecoration(
                color: getColorFromHex(ingredient.name),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              height: 80, // Ajustar el tamaño de la parte superior
              width: double.infinity,
              child: Center(
                child: Text(
                  ingredient.name[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Parte inferior con nombre y cantidad
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      ingredient.name,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Cantidad: ${ingredient.quantityInInventory}",
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color getColorFromHex(String name) {
    List<String> colors = [
      "F56217",
      "F5CC17",
      "00875E",
      "04394E",
      "9C27B0",
      "E91E63",
      "3F51B5",
      "4CAF50",
    ];

    String firstLetter = name.isNotEmpty ? name[0].toUpperCase() : 'A';
    int colorIndex =
        (firstLetter.codeUnitAt(0) - 'A'.codeUnitAt(0)) % colors.length;

    final hexCode = colors[colorIndex].replaceAll("#", "");
    return Color(int.parse("FF$hexCode", radix: 16));
  }
}
