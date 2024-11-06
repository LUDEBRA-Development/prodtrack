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
                  return ListView.builder(
                    itemCount: combinedProductController.filteredcombinedData.length,
                    itemBuilder: (BuildContext context, int index) {
                      final product = combinedProductController.filteredcombinedData[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0, top: 15.0),
                        child: ListTile(
                          onTap: () {
                           
                          },
                          title: Text(
                            '${product.name}',
                            style: const TextStyle(
                                color: Colors.black, fontSize: 23, fontWeight: FontWeight.bold ),
                          ),
                          subtitle: Text(
                            product is Product 
                                ? 'Cantidad:  ${product.quantity} ${"cajas"}'  
                                : product is Ingredient 
                                  ? 'cantidad: ${product.quantityInInventory.toStringAsFixed(2)} ${product.und.name}'  
                                  : 'No disponible',      
                          ),
                          trailing: Text(
                            product is Product 
                                ? '\$${product.boxPrice.toStringAsFixed(2)}'  
                                : product is Ingredient 
                                  ? '\$${product.price}'  
                                  : 'No disponible',
                            style: const TextStyle(
                              fontSize: 18,
                            ),      
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
      ),
    );
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


