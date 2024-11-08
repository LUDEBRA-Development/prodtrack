import 'package:flutter/material.dart';
import 'package:prodtrack/controllers/product_controller.dart';
import 'package:get/get.dart';
import 'package:prodtrack/controllers/sales_invoices_controller.dart';
import 'package:prodtrack/models/product.dart';
import 'package:prodtrack/models/sales_invoice.dart';
import 'package:prodtrack/widgets/format_with_commas.dart';
class CreateSalesInvoicesPage extends StatefulWidget {
  const CreateSalesInvoicesPage({super.key});

  @override
  State<CreateSalesInvoicesPage> createState() => _CreateSalesInvoicesPageState();
}

class _CreateSalesInvoicesPageState extends State<CreateSalesInvoicesPage> {
  final ProductController productController = Get.put(ProductController());
  final SalesInvoiceController salesInvoiceController = Get.put(SalesInvoiceController());
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _productQuantityController = TextEditingController();
  List<Product> selectedProducts = [];
  double totalInvoice = 0.0; 
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
      appBar: AppBar(
        title: const Text('Crear factura de venta'),
        actions: [
            IconButton(
              icon: const Icon(Icons.save, color: Colors.black, size: 50),
              onPressed: () {
                // Crear una factura
                final invoice = SalesInvoice(
                  id: null,
                  date: DateTime.now(),
                  customer: _nameController.text,
                  products: selectedProducts,
                );

                salesInvoiceController.addSalesInvoice(invoice);
                Navigator.of(context).pop(); // Volver a la vista anterior
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Factura creada")),
                );
              },
            ),
          ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              _buildTextField(_nameController, "Nombre cliente", Icons.label),
              const SizedBox(height: 20),
              const Text("Productos seleccionados", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              listWidgetproductesSeleted(),
              totalFacturaWidget(),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomRight, 
                child: _buildProductSection(), // Widget de los productos
              ),
            ],
          ),
        ),
      )
    );
  }

  Widget totalFacturaWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Espaciado
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end, // Alinea el texto a la derecha
        children: [
          const Text(
            "Total",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 33, 243, 79), // Puedes elegir el color que desees
            ),
          ),
          Text(": \$${formatWithCommas(totalInvoice)}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.black),
          ),
          filled: true,
          fillColor: const Color(0xFFcbcbcb),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(icon, color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget listWidgetproductesSeleted() {
    return Column(
      children: selectedProducts.map((item) {
        return Card(
          color: Colors.white, // Fondo blanco para la tarjeta
          elevation: 4, // Elevación para dar un efecto de sombra
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 20, 
                          fontWeight: FontWeight.bold, 
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          const Icon(Icons.attach_money, size: 16),
                          Text(
                            "Precio: \$${formatWithCommas(item.boxPrice)}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          const Icon(Icons.shopping_cart, size: 16),
                          Text(
                            "Cantidad: ${item.quantity}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          const Icon(Icons.payment, size: 16),
                          Text(
                            "Total: \$${formatWithCommas((item.quantity * item.boxPrice).toDouble())}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 50,),
                  onPressed: () async {
                    final confirmDelete = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Confirmar eliminación"),
                          content: Text("¿Estás seguro de que deseas eliminar ${item.name}?"),
                          actions: <Widget>[
                            TextButton(
                              child: const Text("Cancelar"),
                              onPressed: () {
                                Navigator.of(context).pop(false); // No confirmar
                              },
                            ),
                            TextButton(
                              child: const Text("Eliminar"),
                              onPressed: () {
                                Navigator.of(context).pop(true); // Confirmar eliminación
                              },
                            ),
                          ],
                        );
                      },
                    );

                    // Si el usuario confirma, elimina el elemento
                    if (confirmDelete == true) {
                      setState(() { 
                        totalInvoice -= item.quantity * item.boxPrice.toDouble();
                        selectedProducts.remove(item);
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        );
      }).toList(),
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

  Widget _buildProductSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 68, 109, 199),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: IconButton(
             padding: EdgeInsets.zero,
            icon: const Icon(Icons.add, color: Colors.white, size: 70.0, ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.9,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Barra superior con "X" para cerrar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Selecciona Producto",
                              style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.black),
                              onPressed: () {
                                Navigator.of(context).pop(); // Cierra el diálogo
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10), // Espacio entre la barra y el contenido
                        // Campo de búsqueda
                        TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: "Buscar Producto",
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Lista de productes
                        Expanded(
                          child: Obx(() {
                            return ListView.builder(
                              itemCount: productController.filteredProducts.length,
                              itemBuilder: (BuildContext context, int index) {
                                final product = productController.filteredProducts[index];
                                return Container(
                                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey, width: 1.0),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        flex: 5,
                                        child: ListTile(
                                          onTap: () {
                                            _showQuantityDialog(index);
                                          },
                                          title: Text(
                                            product.name,
                                            style: const TextStyle(
                                                color: Colors.black, fontSize: 25.0),
                                          ),
                                          subtitle: Text(
                                            "Cantidad: ${product.quantity} cajas",
                                            style: const TextStyle(
                                                color: Colors.black, fontSize: 17.0),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
  
  void _showQuantityDialog(int index) {
    final product = productController.filteredProducts[index];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Cantidad de ${product.name}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _productQuantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: "Cantidad"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                // Obtiene la cantidad ingresada
                int productQuantity = int.tryParse(_productQuantityController.text) ?? 0;
  
                if (productQuantity > 0  && productQuantity  <= product.quantity) {
                  productController.filteredProducts[index].quantity = product.quantity - productQuantity;  
                  var newProduct = product.copyWith(quantity: productQuantity);
                  totalInvoice += productQuantity * newProduct.boxPrice.toDouble();
                  setState(() {
                    selectedProducts.add(newProduct); 
                  });
                    Get.snackbar("Mensaje", "${product.name} agregado con cantidad: ${productQuantity.toStringAsFixed(2)} ");
                  Navigator.of(context).pop(); // Cierra el diálogo de cantidad
                } else {
                  Get.snackbar("Error", "Por favor, ingresa una cantidad válida ");}
              },
              child: const Text("Agregar"),
            ),
          ],
        );
      },
    );
  }
}


