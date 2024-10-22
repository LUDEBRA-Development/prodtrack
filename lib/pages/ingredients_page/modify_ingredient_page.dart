import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prodtrack/controllers/ingredients_controller.dart';
import 'package:prodtrack/controllers/supplier_controller.dart';
import 'package:prodtrack/models/Ingredient.dart';
import 'package:prodtrack/models/Supplier.dart';
import 'dart:io';

class ModifyIngredientView extends StatefulWidget {
  final Ingredient ingredient; // Proveedor a modificar

  const ModifyIngredientView({super.key, required this.ingredient});

  @override
  State<ModifyIngredientView> createState() => _ModifyIngredientViewState();
}

class _ModifyIngredientViewState extends State<ModifyIngredientView> {
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

  @override
  void initState() {
    super.initState();
    // Inicializar los controladores con los datos del proveedor
    _nameController.text = widget.ingredient.name;
    _quantityUsedController.text = widget.ingredient.quantityUsed.toString();
    _quantityInInventoryController.text =
        widget.ingredient.quantityInInventory.toString();
    _priceController.text = widget.ingredient.price.toString();
    _supplierController.text = widget.ingredient.supplier.toString();
    _undController.text = widget.ingredient.und.toString();
  }

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
          "Modificar Ingrediente",
          style: TextStyle(color: Colors.black),
        ),
        actions: [bottomUpdate(), bottomDelete()],
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
            _buildTextField(_nameController, "Nombre", Icons.blender_rounded),
            _buildTextField(
                _quantityUsedController, "Cantidad", Icons.app_registration),
            _buildTextField(_quantityInInventoryController,
                "Cantidad en el Inventario", Icons.addchart),
            _buildTextField(_priceController, "Precio", Icons.attach_money),
            _buildTextField(_supplierController, "Proveedor", Icons.person),
            _buildTextField(_undController, "Unidad", Icons.assignment_add),
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
            padding: const EdgeInsets.all(12.0),
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

  Widget bottomDelete() {
    return IconButton(
      icon: const Icon(
        Icons.delete,
        color: Colors.black,
        size: 50,
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirmar eliminación"),
              content: Text(
                  "¿Está seguro de que desea eliminar a ${widget.ingredient.name}?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () {
                    ingredientController
                        .deleteIngredient(widget.ingredient.id.toString());
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("${widget.ingredient.name} eliminado")),
                    );
                  },
                  child: const Text("Eliminar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget bottomUpdate() {
    return IconButton(
      icon: const Icon(
        Icons.edit,
        color: Colors.black,
        size: 50,
      ),
      onPressed: () async {
        Ingredient updatedIngredient = Ingredient(
          id: widget.ingredient.id,
          name: _nameController.text,
          quantityUsed:
              double.parse(_quantityUsedController.text), // Convertir a double
          quantityInInventory: double.parse(
              _quantityInInventoryController.text), // Convertir a double
          price: double.parse(_priceController.text), // Convertir a double
          supplier: widget.ingredient.supplier, // Mantener el mismo proveedor
          und: widget.ingredient.und, // Mantener la misma unidad
        );
        await ingredientController.updateIngredient(updatedIngredient);
        Navigator.of(context).pop(); // Volver a la vista anterior
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${updatedIngredient.name} actualizado")),
        );
      },
    );
  }
}
