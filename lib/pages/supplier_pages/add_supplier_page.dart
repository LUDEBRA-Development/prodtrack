import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prodtrack/controllers/supplier_controller.dart';
import 'package:prodtrack/models/Supplier.dart';
import 'dart:io';
class CreateSupplierView extends StatefulWidget {
  const CreateSupplierView({super.key});

  @override
  State<CreateSupplierView> createState() => _CreateSupplierViewState();
}

class _CreateSupplierViewState extends State<CreateSupplierView> {
  final SupplierController supplierController = Get.put(SupplierController());
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _gmailController = TextEditingController();
  final TextEditingController _webSiteController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nitController = TextEditingController();
    final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
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
          "Crear Proveedor",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.black, size: 50,),
            onPressed: () {
              // Crear nuevo proveedor
              Supplier newSupplier = Supplier(
                name: _nameController.text,
                phone: _phoneController.text,
                gmail: _gmailController.text,
                webSite: _webSiteController.text,
                address: _addressController.text,
                nit: _nitController.text,
              );
              supplierController.addSupplier(newSupplier);
              Navigator.of(context).pop(); // Volver a la vista anterior
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${newSupplier.name} guardado")),
              );
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
          SizedBox(height: 30,),
          _buildTextField(_nameController, "Nombre", Icons.person),
          _buildTextField(_phoneController, "Teléfono", Icons.phone),
          _buildTextField(_gmailController, "Gmail", Icons.email),
          _buildTextField(_webSiteController, "Sitio Web", Icons.public),
          _buildTextField(_addressController, "Dirección", Icons.location_on),
          _buildTextField(_nitController, "NIT", Icons.business),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon) {
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
          onTap: _pickImage, // Permite seleccionar la imagen al tocar el contenedor
          child: Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              color: const Color(0xFFcbcbcb), // Color de fondo
              shape: BoxShape.circle, // Forma circular
              image: _image == null
                  ? null // No hay imagen seleccionada
                  : DecorationImage(
                      image: FileImage(File(_image!.path)), // Imagen seleccionada
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