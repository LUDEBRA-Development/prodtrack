import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:prodtrack/controllers/ingredients_controller.dart';
import 'package:prodtrack/models/Ingredient.dart';
import 'package:prodtrack/models/Supplier.dart';
import 'package:prodtrack/models/Und.dart'; // Asegúrate de importar estos modelos

class CreateIngredientView extends StatefulWidget {
  const CreateIngredientView({super.key});

  @override
  State<CreateIngredientView> createState() => _CreateIngredientViewState();
}

class _CreateIngredientViewState extends State<CreateIngredientView> {
  final IngredientsController ingredientController =
      Get.put(IngredientsController());
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityUsedController = TextEditingController();
  final TextEditingController _quantityInInventoryController =
      TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _supplierController = TextEditingController();
  final TextEditingController _undController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFdcdcdc),
      appBar: AppBar(
        backgroundColor: const Color(0xFFdcdcdc),
        title: const Text(
          "Crear Ingredientes",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.save,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              // Crear nuevo ingrediente

              try {
                Ingredient newIngredient = Ingredient(
                  name: _nameController.text,
                  quantityUsed: double.parse(_quantityUsedController.text),
                  quantityInInventory:
                      double.parse(_quantityInInventoryController.text),
                  price: double.parse(_priceController.text),
                  supplier: Supplier(
                    name: _supplierController.text,
                    phone: '123456789',
                    gmail: 'supplier@example.com',
                    webSite: 'www.supplier.com',
                    address: 'Supplier address',
                    nit: '1234567890',
                  ),
                  und: Und(
                    'Unidad de Medida',
                    '2', // ID de la unidad
                    1, // Valor de la unidad
                  ),
                );

                ingredientController.addIngredient(newIngredient);
                Navigator.of(context).pop(); // Volver a la vista anterior
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${newIngredient.name} guardado")),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Error al guardar el ingrediente")),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Botón para agregar foto
            image(),
            const SizedBox(
              height: 30,
            ),
            _buildTextField(_nameController, "Nombre", Icons.person),
            _buildTextField(
                _quantityUsedController, "Cantidad Usada", Icons.numbers),
            _buildTextField(_quantityInInventoryController,
                "Cantidad en el Inventario", Icons.numbers),
            _buildTextField(_priceController, "Precio", Icons.attach_money),
            _buildTextField(
                _supplierController, "Proveedor", Icons.location_on),
            _buildTextField(_undController, "Unidad", Icons.business),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hint, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.black),
          ),
          filled: true,
          fillColor: const Color(0xFFcbcbcb),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0), // Padding around the icon
            child: Icon(icon, color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget image() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap:
              _pickImage, // Permite seleccionar la imagen al tocar el contenedor
          child: Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              color: const Color(0xFFcbcbcb), // Color de fondo
              shape: BoxShape.circle, // Forma circular
              image: _image == null
                  ? null // No hay imagen seleccionada
                  : DecorationImage(
                      image:
                          FileImage(File(_image!.path)), // Imagen seleccionada
                      fit: BoxFit.cover, // Ajustar la imagen al contenedor
                    ),
            ),
            child: _image == null
                ? const Icon(
                    Icons.add_a_photo, // Icono de agregar imagen
                    color: Colors.black, // Color del icono
                    size: 80, // Tamaño del icono
                  )
                : null, // No muestra nada si hay imagen
          ),
        ),
      ],
    );
  }
}
