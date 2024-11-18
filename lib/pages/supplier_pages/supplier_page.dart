import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prodtrack/controllers/supplier_controller.dart';
import 'package:prodtrack/models/Supplier.dart';
import 'package:prodtrack/pages/supplier_pages/add_supplier_page.dart';
import 'package:prodtrack/pages/supplier_pages/modifi_supplier_page.dart';
import 'package:prodtrack/widgets/avatar.dart';
import 'package:prodtrack/widgets/seach.dart';

class SupplierView extends StatefulWidget {
  const SupplierView({super.key});

  @override
  State<SupplierView> createState() => _SupplierViewState();
}

class _SupplierViewState extends State<SupplierView> {
  final SupplierController supplierController = Get.put(SupplierController()); // Controlador
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      supplierController.filterSuppliers(_searchController.text);
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
              "Proveedores",
              style: TextStyle(color: Colors.black, fontSize: 40, fontFamily: "Regular", height: 20),
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
            child: searchBar(_searchController, "Buscar proveedores"),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 90.0, top: 10.0),
            child: addSupplierButton(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 40.0, right: 40.0),
              child: Obx(() {
                return ListView.builder(
                  itemCount: supplierController.filteredSuppliers.length,
                  itemBuilder: (BuildContext context, int index) {
                    final supplier =
                        supplierController.filteredSuppliers[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                      child: ListTile(
                        onTap: () {
                          Get.to(() => ModifySupplierView(supplier: supplier));
                        },
                        title: Text(
                          supplier.name,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 35, fontFamily: "Regular"),
                        ),
                        subtitle: Text(
                          supplier.phone,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 20, fontFamily: "Regular"),
                        ),
                        leading: imageProfile(supplier),
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



  Widget addSupplierButton() {
    return Container(
      color: const Color(0xFFdcdcdc),
      padding: const EdgeInsets.only(right: 5.0, top: 8.0, bottom: 8.0),
      child: ElevatedButton(
        onPressed: () {
          Get.to(() => const CreateSupplierView());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFdcdcdc),
          elevation: 0,
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person_add_alt_1_sharp,
              color: Color.fromRGBO(0, 0, 0, 1),
              size: 48,
            ),
            SizedBox(width: 30),
            Text(
              "Añadir Proveedor",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }



  void printSupplier(Supplier supplier) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(supplier.id.toString())),
    );
  }

    Widget imageProfile(Supplier supplier) {
    return Image.network(
       supplier.urlProfilePhoto.toString(),
       loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
         if (loadingProgress == null) {
           return child;
         } else {
           return Center(
             child: CircularProgressIndicator(
               value: loadingProgress.expectedTotalBytes != null
                   ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                   : null,
             ),
           );
         }
       },
       errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
         return avatar(supplier.urlProfilePhoto.toString());
       },
     );
  }
}
