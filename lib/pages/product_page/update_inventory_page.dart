import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prodtrack/controllers/account_Payable_controller.dart';
import 'package:prodtrack/controllers/employee_contoller.dart';
import 'package:prodtrack/controllers/product_controller.dart';
import 'package:prodtrack/models/account_payable.dart';
import 'package:prodtrack/models/employee.dart';
import 'package:prodtrack/models/product.dart';
import 'package:prodtrack/pages/index_pages.dart';
import 'package:prodtrack/pages/product_page/product_page.dart';
import 'package:prodtrack/widgets/seach.dart';

class UpdateInventoryPage extends StatefulWidget {
  final Product product;
  const UpdateInventoryPage({super.key, required this.product});

  @override
  State<UpdateInventoryPage> createState() => _UpdateInventoryPageState();
}

class _UpdateInventoryPageState extends State<UpdateInventoryPage> {
  final EmployeeController employeeController = Get.put(EmployeeController());
  final ProductController productController = Get.put(ProductController());
  final AccountPayableController accountPayableController = Get.put(AccountPayableController());
  
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController amountControllerr = TextEditingController();
  List<Employee> _employeesSelected = [];
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      employeeController.filterEmployee(_searchController.text);
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
          title: const  Row(
            children: [
                Text(
                  "Gestión de inventario ",
                  style: TextStyle(color: Colors.black, fontSize: 30, fontFamily: "Regular", height: 20),
                ),
               
            ],
          ),
          ),
        ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: amountControllerr,
              decoration: InputDecoration(
                hintText: "Cantidad de cajas fabricadas",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                filled: true,
                fillColor: const Color(0xFFcbcbcb),
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Icon(Icons.confirmation_number, color: Colors.black),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 40.0, right: 40.0),
            child: searchBar(_searchController, "Buscar empleados"),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 40.0, right: 40.0),
              child: Obx(() {
                return ListView.builder(
                  itemCount: employeeController.filteredEmployees.length,
                  itemBuilder: (BuildContext context, int index) {
                    final employee = employeeController.filteredEmployees[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            // Agregar empleado a la lista seleccionada
                            if (!_employeesSelected.contains(employee)) {
                              _employeesSelected.add(employee);
                            }else {
                              _employeesSelected.remove(employee);
                            }
                          });
                        },
                        title: Text(
                          employee.name,
                          style: const TextStyle(color: Colors.black, fontSize: 20, fontFamily: "Regular"),
                        ),
                        subtitle: Text(
                          employee.id.toString(),
                          style: const TextStyle(color: Colors.black, fontSize: 15, fontFamily: "Regular"),
                        ),
                        leading: avatar(employee.name),
                        trailing: Container(
                          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(50.0)),
                          child: Icon(
                             _employeesSelected.contains(employee) ? Icons.remove : Icons.add,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        _buildUpdateButton(),
        ],
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

    String firstLetter = name.isNotEmpty ? name[0].toUpperCase() : 'A';
    int colorIndex = (firstLetter.codeUnitAt(0) - 'A'.codeUnitAt(0)) % colors.length;

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


Widget _buildUpdateButton() {
  return Padding(
      padding: const EdgeInsets.all(25.0),
      child:Card(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0, top: 8.0, left: 35.0, right: 35.0),
              child: Text(
                "Empleados Seleccionados",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Column(
              children: _employeesSelected.map((employee) {
                return ListTile(
                  title: Text(
                    "*  ${employee.name}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const  Color(0xFFec1074),
                  minimumSize: const Size(250, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  
                ),
                onPressed: () async {
                  if (_employeesSelected.isEmpty) {
                    _showSnackBar(context, "Por favor, seleccione al menos un empleado.");
                    return;
                  }
                  
                  if (amountControllerr.text.isEmpty) {
                    _showSnackBar(context, "Por favor, ingrese la cantidad de producto.");
                    return;
                  }

                  int? quantityNew = int.tryParse(amountControllerr.text);
                  if (quantityNew == null) {
                    _showSnackBar(context, "Cantidad no válida. Ingrese un número entero.");
                    return;
                  }

                  setState(() {
                    _isLoading = true;
                  });

                  try {
                    const double priceLabour = 800;
                    double amount = (quantityNew * priceLabour) / _employeesSelected.length;

                    AccountPayable accountPayable = AccountPayable(
                      beneficiary: _employeesSelected[0],
                      dueDate: DateTime.now().add(const Duration(days: 30)),
                      amount: amount,
                    );

                    await productController.updateQuantity(context, widget.product, quantityNew);
                    await accountPayableController.addAccountPayable(accountPayable);

                    Get.offAll(() => const indexPages());

                  } catch (e) {
                    _showSnackBar(context, "Ocurrió un error. Inténtelo nuevamente.");

                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                },
                child: const Text("Guardar", style: 
                TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )
                ,),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
