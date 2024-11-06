
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prodtrack/controllers/employee_contoller.dart';
import 'package:prodtrack/models/employee.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:prodtrack/models/product.dart';
import 'package:prodtrack/pages/product_page/update_inventory_page.dart';

class ModifyProductView extends StatefulWidget {
  final Product product;
  const ModifyProductView({super.key, required this.product});

  @override
  State<ModifyProductView> createState() => _ModifyProductViewState();
}

class _ModifyProductViewState extends State<ModifyProductView> {
  

  final EmployeeController employeeController = Get.put(EmployeeController());

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceLabelController = TextEditingController();
  final TextEditingController _priceLabeledController = TextEditingController();
  final TextEditingController _priceBoxContoller = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  
  @override
  void initState() {
    super.initState();
    _nameController.text = widget.product.name;
    _descriptionController.text = widget.product.description;
    _quantityController.text = widget.product.quantity.toString();
    _priceLabelController.text = widget.product.priceLabel.toString();
    _priceLabeledController.text = widget.product.priceLabeled.toString();
    _priceBoxContoller.text = widget.product.boxPrice.toStringAsFixed(2)?.toString() ?? '0.0';


  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
      print('Imagen seleccionada: ${_image!.path}');
    } else {
      print('No se ha seleccionado ninguna imagen.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFdcdcdc),
      appBar: AppBar(
        backgroundColor: const Color(0xFFdcdcdc),
        title: const Text(
          "Modificar Producto",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          _buildUpdateButton(),
          _buildDeleteButton()
        ],
      ),/*  */
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
            children: [
              _buildImagePicker(),
              const SizedBox(height: 30),
              _buildTextField(true,  _nameController, "Nombre", Icons.label),
              _buildTextField(true,  _descriptionController, "Descripción", Icons.description),
              _buildTextField(false,  _quantityController, "Cantidad disponible", Icons.confirmation_number),
              _buildTextField(true,  _priceLabelController, "Precio de  etiqueta", Icons.price_check),
              _buildTextField(true,  _priceLabeledController, "Precio  etiquetado", Icons.price_change),
              _buildTextField(false,  _priceBoxContoller,  "Precio de caja", Icons.price_change),
              const SizedBox(height: 30),
              _buildAddPInventoryButton()

            ],
                    ),
          ),
        )
      ),
    );
  }
Widget _buildTextField(bool status, TextEditingController controller, String hint, IconData icon) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, 
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          hint, 
          style: const TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 16.0, 
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8.0), 
        TextField(
          enabled: status,
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
      ],
    ),
  );
}


  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          color: const Color(0xFFcbcbcb),
          shape: BoxShape.circle,
          image: _image != null
              ? DecorationImage(
                  image: FileImage(File(_image!.path)),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: _image == null
            ? const Icon(
                Icons.add_a_photo,
                color: Colors.black,
                size: 80,
              )
            : null,
      ),
    );
  }

  Widget _buildDeleteButton() {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.black, size: 50),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirmar eliminación"),
              content: Text("¿Está seguro de que desea eliminar el producto ${widget.product.name}?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () {
                    // Lógica para eliminar el producto
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${widget.product.name} eliminado")),
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

  Widget _buildUpdateButton() {
    return IconButton(
      icon: const Icon(Icons.edit, color: Colors.black, size: 50),
      onPressed: () async {
        // Lógica para actualizar el producto
        Product updatedProduct = Product(
          widget.product.id,
          _nameController.text,
          _descriptionController.text,
          int.parse(_quantityController.text),
          widget.product.packing,
          widget.product.box,
          widget.product.ingredients,
          double.parse(_priceLabelController.text),
          double.parse(_priceLabeledController.text),
        );

        // Aquí actualizar el producto en la base de datos
                        
      },
    );
  }

  Widget _buildAddPInventoryButton() {
    return Column(
      children: [
        const  Center(
          child:  Text("Actualizar inventario",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        ),
        const SizedBox(height: 10.0),
        Container(
          decoration: BoxDecoration( color: Colors.black, borderRadius: BorderRadius.circular(10.0)),
          child: IconButton(
            icon: const Icon(Icons.add, color: Colors.white, size: 70),
            onPressed: () async {
              // Lógica para actualizar el producto
              Product updatedProduct = Product(
                widget.product.id,
                _nameController.text,
                _descriptionController.text,
                int.parse(_quantityController.text),
                widget.product.packing,
                widget.product.box,
                widget.product.ingredients,
                double.parse(_priceLabelController.text),
                double.parse(_priceLabeledController.text),
              );
              Get.to(()=> UpdateInventoryPage(product: updatedProduct));
            },
          ),         
        ),
      ],
    );
  }


}




