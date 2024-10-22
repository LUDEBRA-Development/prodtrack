import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prodtrack/controllers/product_controller.dart';
import 'package:prodtrack/widgets/seach.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final ProductController productController = Get.put(ProductController()); // Controlador
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      productController.filterProducts(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFdcdcdc),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
          backgroundColor: const Color(0xFFdcdcdc),
          title: const Center(
            child: Text(
              "Productos",
              style: TextStyle(color: Colors.black, fontSize: 34, height: 20),
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 40.0, right: 40.0),
            child: searchBar(_searchController, "Buscar productos"),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 90.0, top: 10.0),
            child: addProductButton(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 40.0, right: 40.0),
              child: Obx(() {
                return ListView.builder(
                  itemCount: productController.filteredProducts.length,
                  itemBuilder: (BuildContext context, int index) {
                    final product = productController.filteredProducts[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                      child: ListTile(
                        onTap: () {
                          print(product.id);
                        },
                        title: Text(
                          '${product.name} - \$${product.boxPrice}',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 20),
                        ),
                        leading: avatar(product.name),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget addProductButton() {
    return Container(
      color: const Color(0xFFdcdcdc),
      padding: const EdgeInsets.only(right: 5.0, top: 8.0, bottom: 8.0),
      child: ElevatedButton(
        onPressed: () {
          print("Agregar producto");
          /* Get.to(() => const AddProductPage()); */
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFdcdcdc),
          elevation: 0,
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_box,
              color: Color.fromRGBO(0, 0, 0, 1),
              size: 48,
            ),
            SizedBox(width: 30),
            Text(
              "Añadir Producto",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget avatar(String name) {
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

    Color getColorFromHex(String hexColor) {
      final hexCode = hexColor.replaceAll("#", "");
      return Color(int.parse("FF$hexCode", radix: 16));
    }

    // Obtener la letra inicial y convertirla a mayúscula
    String firstLetter = name.isNotEmpty ? name[0].toUpperCase() : 'P';

    // Calcular el índice basado en la letra inicial (A=0, B=1, ..., Z=25)
    int colorIndex =
        (firstLetter.codeUnitAt(0) - 'A'.codeUnitAt(0)) % colors.length;

    return CircleAvatar(
      backgroundColor: getColorFromHex(colors[colorIndex]),
      radius: 30,
      child: Text(
        firstLetter,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32,
        ),
      ),
    );
  }
}
