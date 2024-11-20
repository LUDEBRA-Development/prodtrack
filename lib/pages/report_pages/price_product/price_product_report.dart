import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prodtrack/controllers/combined_product.dart';
import 'package:prodtrack/models/Ingredient.dart';
import 'package:prodtrack/models/product.dart';
import 'package:prodtrack/widgets/seach.dart';

class PriceProductReport extends StatefulWidget {
  const PriceProductReport({super.key});

  @override
  State<PriceProductReport> createState() => _PriceProductReportState();
}

class _PriceProductReportState extends State<PriceProductReport> {
  final CombinedProductController combinedProductController = Get.put(CombinedProductController()); 
  final TextEditingController _searchController = TextEditingController();
  var selectedStatus = 'Todos'.obs; 
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      combinedProductController.filterProductsCombinedData(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 241, 241),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom:  10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 40.0, right: 40.0),
              child: searchBar(_searchController, "Buscar productos"),
            ),
            const SizedBox(height:8.0 ,),
            filterAccountsPayableSelector(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                child: Obx(() {
                  if (combinedProductController.filteredIngredients.isEmpty) {
                    return const Center(
                      child: Text("No hay productos disponibles."),
                    );
                  }else{

                  }
                  return GridView.builder(
                    gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Cards por fila
                        childAspectRatio: 0.75, // Relación de aspecto para achicar
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                    itemCount: combinedProductController.filteredcombinedData.length,
                    itemBuilder: (BuildContext context, int index) {
                      final product = combinedProductController.filteredcombinedData[index];
                      return productCard(product);
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

 Widget productCard(var product) {
    return GestureDetector(
      onTap: () {
       
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
                color: getColorFromHex(product.name),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              height: 80, // Ajustar el tamaño de la parte superior
              width: double.infinity,
              child: Center(
                child: Text(
                  product.name[0].toUpperCase(),
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
                      product.name,
                      style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),

                    //cantidad
                    Text(
                      product is Product 
                        ? 'Cantidad:  ${product.quantity.toStringAsFixed(2)} ${"cajas"}'  
                        : product is Ingredient 
                          ? 'cantidad: ${product.quantityInInventory.toStringAsFixed(2)} ${product.und.name}'  
                          : 'No disponible',    
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),


                    //cantidad
                    Text(
                      product is Product 
                        ? '\$${product.boxPrice.toStringAsFixed(2)}'  
                        : product is Ingredient 
                          ? '\$${product.price.toStringAsFixed(2)}'  
                          : 'No disponible',    
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




  Widget filterAccountsPayableSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        filterButton('Todos'),
        const SizedBox(width: 10),
        filterButton('Fabricados'),
        const SizedBox(width: 10),
        filterButton('Insumos'),
      ],
    );
  }

  Widget filterButton(String status) {
    return TextButton(
      onPressed: () {
        selectedStatus.value = status; // Cambiar el estado
        combinedProductController.filterProductsForType(
          _searchController.text,
          status: selectedStatus.value,
        );
      },
      child: Obx(() {
        return Text(
          status,
          style: TextStyle(
            color: selectedStatus.value == status ? Colors.blue : Colors.black,
          ),
        );
      }),
    );
  }
  
}


