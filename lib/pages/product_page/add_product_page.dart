import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:prodtrack/controllers/ingredients_controller.dart';
import 'package:prodtrack/controllers/product_controller.dart';
import 'package:prodtrack/models/Box.dart';
import 'package:prodtrack/models/Packing.dart';
import 'package:prodtrack/models/Ingredient.dart';
import 'package:prodtrack/models/Supplier.dart';
import 'package:prodtrack/models/Und.dart';
import 'package:prodtrack/models/product.dart';


class CreateProductView extends StatefulWidget {
  const CreateProductView({super.key});

  @override
  State<CreateProductView> createState() => _CreateProductViewState();
}

class _CreateProductViewState extends State<CreateProductView> {
  final ProductController productController = Get.put(ProductController());
  final IngredientsController ingredientsController = Get.put(IngredientsController());
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceLabelController = TextEditingController();
  final TextEditingController _priceLabeledController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  final TextEditingController _ingredientQuantityController = TextEditingController();
  String? _selectedUnit; 
  // Opciones para Packing y Box
  List<Packing> packingOptions = [
    Packing("1", "pep 500 ml", Und("1", "500 ml", 500), Supplier(id: "1", address: "cra 19", name: "Suresh", nit: "123", phone: "123445", gmail: "suresh@suresh.com", webSite: "empersa.com"), 301.07),
    Packing("2", "pep 850 ml", Und("2", "850 ml", 850), Supplier(id: "2", address: "cra 20", name: "CompanyB", nit: "456", phone: "67890", gmail: "companyb@company.com", webSite: "companyb.com"), 500),
  ];
  List<Box> boxOptions = [
    Box("1", "Caja de 500", 800, 10, 24),
    Box("2", "Caja de 850", 800, 20, 12),
  ];

  Packing? selectedPacking;
  Box? selectedBox;
  List<Ingredient> selectedIngredients = [];

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      ingredientsController.filterIngredients(_searchController.text);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFdcdcdc),
      appBar: AppBar(
        backgroundColor: const Color(0xFFdcdcdc),
        title: const Text(
          "Crear Producto",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.black, size: 50),
            onPressed: () {
              // Crear nuevo producto
              Product newProduct = Product(
                null,
                _nameController.text,
                _descriptionController.text,
                int.parse(_quantityController.text),
                selectedPacking!,
                selectedBox!,
                selectedIngredients,
                double.parse(_priceLabelController.text),
                double.parse(_priceLabeledController.text),
              );
              int? priceLabelNew = int.tryParse(_priceLabelController.text);
              int? priceLabeledNew = int.tryParse(_priceLabeledController.text);
              if ((priceLabeledNew == null) || (priceLabelNew == null) ) {
                _showSnackBar(context, "Precio no válida. Ingrese un número entero.");
                return;
              }
              productController.addProduct(newProduct);
              Navigator.of(context).pop(); // Volver a la vista anterior
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${newProduct.name} guardado")),
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
              image(), // Widget para mostrar y seleccionar imagen
              const SizedBox(height: 30),
              _buildTextField(_nameController, "Nombre del Producto", Icons.label),
              _buildTextField(_descriptionController, "Descripción", Icons.description),
              _buildTextField(_quantityController, "Cantidad", Icons.production_quantity_limits, isNumeric: true),
              _buildDropdownPacking(),
              _buildDropdownBox(),
              _buildTextField(_priceLabelController, "Precio de  etiqueta", Icons.price_change, isNumeric: true),
              _buildTextField(_priceLabeledController, "Precio  del etiquetado", Icons.price_check, isNumeric: true),
              const SizedBox(height: 20),
              const Text("Ingredientes seleccionados", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              listWidgetIngredientesSeleted(),
              const SizedBox(height: 20),
              _buildIngredientSection(), // Sección para agregar ingredientes
            ],
          ),
        ),
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

  Widget _buildDropdownPacking() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<Packing>(
        value: selectedPacking,
        hint: const Text("Selecciona el envase"),
        items: packingOptions.map((Packing packing) {
          return DropdownMenuItem<Packing>(
            value: packing,
            child: Text(packing.name),
          );
        }).toList(),
        onChanged: (Packing? newPacking) {
          setState(() {
            selectedPacking = newPacking;
          });
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          filled: true,
          fillColor: const Color(0xFFcbcbcb),
        ),
      ),
    );
  }

  Widget _buildDropdownBox() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<Box>(
        value: selectedBox,
        hint: const Text("Selecciona Caja"),
        items: boxOptions.map((Box box) {
          return DropdownMenuItem<Box>(
            value: box,
            child: Text(box.name),
          );
        }).toList(),
        onChanged: (Box? newBox) {
          setState(() {
            selectedBox = newBox;
          });
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          filled: true,
          fillColor: const Color(0xFFcbcbcb),
        ),
      ),
    );
  }

  Widget image() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              color: const Color(0xFFcbcbcb),
              shape: BoxShape.circle,
              image: _image == null
                  ? null
                  : DecorationImage(
                      image: FileImage(File(_image!.path)),
                      fit: BoxFit.cover,
                    ),
            ),
            child: _image == null
                ? const Icon(
                    Icons.add_a_photo,
                    color: Colors.black,
                    size: 80,
                  )
                : null,
          ),
        ),
      ],
    );
  }
Widget _buildIngredientSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      IconButton(
        icon: const Icon(Icons.add_circle, color: Colors.black, size: 60.0),
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
                          "Selecciona Ingrediente",
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
                        hintText: "Buscar insumo",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Lista de ingredientes
                    Expanded(
                      child: Obx(() {
                        return ListView.builder(
                          itemCount: ingredientsController.filteredIngredients.length,
                          itemBuilder: (BuildContext context, int index) {
                            final ingredient = ingredientsController.filteredIngredients[index];
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
                                        ingredient.name,
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 25.0),
                                      ),
                                      subtitle: Text(
                                        "Cantidad: ${ingredient.quantityInInventory.toStringAsFixed(2)} ${ingredient.und.name}",
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 17.0),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 70,
                                    width: 50,
                                    child: avatar(ingredient.name),
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
    ],
  );
}


void _showQuantityDialog(int index) {
  final ingredient = ingredientsController.filteredIngredients[index];
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Cantidad de ${ingredient.name}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dropdown para seleccionar la unidad (kg o g)
            DropdownButton<String>(
              hint: const Text("Seleccionar unidad"),
              value: _selectedUnit,
              items: <String>['kg', 'g'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedUnit = newValue; 
                });
              },
            ),
            TextField(
              controller: _ingredientQuantityController,
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
              double ingredientQuantity = double.tryParse(_ingredientQuantityController.text) ?? 0;
              if(_selectedUnit == 'g'){
                ingredientQuantity = ingredientQuantity / 1000;
              }
              if (ingredientQuantity > 0 && _selectedUnit != null && ingredientQuantity  <= ingredient.quantityInInventory) {
                ingredientsController.filteredIngredients[index].quantityInInventory = ingredient.quantityInInventory - ingredientQuantity;  // Restamos la cantidad
                double quantityToStore = ingredientQuantity;


                // Convertir gramos a kilogramos si la unidad seleccionada es gramos
                if (_selectedUnit == 'g') {
                  quantityToStore = ingredientQuantity / 1000; // Conversión de g a kg
                }
                setState(() {
                  ingredient.quantityUsed = quantityToStore; // Almacena la cantidad en kg
                 // Guarda la unidad seleccionada
                  selectedIngredients.add(ingredient); // Agrega el ingrediente a la lista
                });
                  Get.snackbar("Mensaje", "${ingredient.name} agregado con cantidad: ${quantityToStore.toStringAsFixed(2)} kg");
                Navigator.of(context).pop(); // Cierra el diálogo de cantidad
              } else {
                Get.snackbar("Error", "Por favor, ingresa una cantidad válida y selecciona una unidad");}
            },
            child: const Text("Agregar"),
          ),
        ],
      );
    },
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

    // Función para convertir un código hexadecimal en un color de Flutter
    Color getColorFromHex(String hexColor) {
      final hexCode = hexColor.replaceAll("#", "");
      return Color(int.parse("FF$hexCode", radix: 16));
    }

    // Obtener la letra inicial y convertirla a mayúscula
    String firstLetter = name.isNotEmpty ? name[0].toUpperCase() : 'A';

    // Calcular el índice basado en la letra inicial
    int colorIndex = (firstLetter.codeUnitAt(0) - 'A'.codeUnitAt(0)) % colors.length;

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: getColorFromHex(colors[colorIndex]), // Color del borde
              width: 2.0, // Ancho del borde
            ),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          firstLetter,
          style: TextStyle(
            color: getColorFromHex(colors[colorIndex]), // Obtener el color aquí
            fontSize: 30,
          ),
        ),
      ),
    );
  }

  Widget listWidgetIngredientesSeleted() {
    return Column(
      children: selectedIngredients.map((item) {
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
                    Text(
                      item.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text("Cantidad: ${item.quantityUsed} ${item.und.name}"),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
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
                        selectedIngredients.remove(item);
                        int index = ingredientsController.filteredIngredients.indexOf(item);
                        ingredientsController.filteredIngredients[index].quantityInInventory +=  item.quantityUsed;  // Sumamos la cantidad
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

}


  

