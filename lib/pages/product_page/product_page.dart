import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prodtrack/controllers/product_controller.dart';
import 'package:prodtrack/models/product.dart';
import 'package:prodtrack/pages/product_page/add_product_page.dart';
import 'package:prodtrack/pages/product_page/modifify_product_page.dart';
import 'package:prodtrack/pages/product_page/update_inventory_page.dart';
import 'package:prodtrack/widgets/avatar.dart';
import 'package:prodtrack/widgets/seach.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final ProductController productController = Get.put(ProductController()); // Controlador
  final TextEditingController _searchController = TextEditingController();
  List<Product> productSelectedColor = [];
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
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          title: Obx(() {
            final count = productController.selectedProducts.length;
            return Text(count > 0 ? '$count ' : 'Productos', 
            style: const TextStyle(color: Colors.black, fontSize: 30, height: 20));
          }),
          actions: [
            Obx(() {
              if (productController.selectedProducts.isEmpty) {
                return Container(); // No mostrar acciones si no hay selección
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {   
                    Get.to(()=>  UpdateInventoryPage(selectedProducts : productController.selectedProducts));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const  Color(0xFFec1074),
                    minimumSize: const Size(250, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text("Actulizar inventario", style: 
                    TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )
                  ,),
                ),
              );
            }),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 8.0),
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
                    final isSelected = productController.selectedProducts.contains(product);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                      child: ListTile(
                        onTap: () {   
                          setState(() {
                            if (productController.isSelectionMode) {
                              productController.toggleSelection(product);
                            } else {
                              // Si no está en modo selección, navega a modificar
                              Get.to(() => ModifyProductView(product: product));
                            }                            
                          });
                        },
                        onLongPress: () {
                          setState(() {
/*                             if (!productSelectedColor.contains(product)) {
                              productSelectedColor.add(product);
                            }else {
                              productSelectedColor.remove(product);
                            } */
                            productController.toggleSelection(product);   
                          });
                        },
                        selected: isSelected,
                        selectedTileColor: Colors.blue.withOpacity(0.2),
                        title: Text(
                          '${product.name} - \$${product.boxPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: isSelected ? Colors.blue : Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        subtitle: Text('Cantidad: ${product.quantity}'),
                        leading: avatar(product.name),
                        trailing: productController.selectedProducts.contains(product)
                            ? const Icon(
                                Icons.check_circle,
                                color: Colors.blue,
                                size: 24,
                              )
                            : const Icon(
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
          Get.to(()=> const CreateProductView());
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


}

