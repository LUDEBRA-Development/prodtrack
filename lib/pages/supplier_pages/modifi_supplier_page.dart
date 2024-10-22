import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prodtrack/controllers/storage_Controller.dart';
import 'package:prodtrack/controllers/supplier_controller.dart';
import 'package:prodtrack/models/Supplier.dart';
import 'dart:io';

class ModifySupplierView extends StatefulWidget {
  final Supplier supplier; // Proveedor a modificar

  const ModifySupplierView({super.key, required this.supplier});

  @override
  State<ModifySupplierView> createState() => _ModifySupplierViewState();
}

class _ModifySupplierViewState extends State<ModifySupplierView> {
  final SupplierController supplierController = Get.put(SupplierController());
  final StorageController storageController = Get.put(StorageController());
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _gmailController = TextEditingController();
  final TextEditingController _webSiteController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nitController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  @override
  void initState() {
    super.initState();
    // Inicializar los controladores con los datos del proveedor
    _nameController.text = widget.supplier.name;
    _phoneController.text = widget.supplier.phone;
    _gmailController.text = widget.supplier.gmail;
    _webSiteController.text = widget.supplier.webSite.toString();
    _addressController.text = widget.supplier.address;
    _nitController.text = widget.supplier.nit;
    // Aquí puedes establecer una imagen inicial si es necesario
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
          "Modificar",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          bottomUpdate(),
          bottomDelete()
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Botón para agregar foto
            image(),
            const SizedBox(height: 30,),
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
            padding: const EdgeInsets.all(12.0),
            child: Icon(icon, color: Colors.black),
          ),
        ),
      ),
    );
  }
  


Widget image() {
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
              : widget.supplier.urlProfilePhoto != null
                  ? DecorationImage(
                      image: NetworkImage(widget.supplier.urlProfilePhoto!),
                      fit: BoxFit.cover,
                    )
                  : null,
        ),
        child: _image == null && widget.supplier.urlProfilePhoto == null
            ? const Icon(
                Icons.add_a_photo,
                color: Colors.black,
                size: 80,
              )
            : null,
      ),
    );
}





  Widget bottomDelete(){
    return  IconButton(
            icon: const Icon(Icons.delete, color: Colors.black, size: 50,),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Confirmar eliminación"),
                    content: Text("¿Está seguro de que desea eliminar a ${widget.supplier.name}?"),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); 
                        },
                        child: const Text("Cancelar"),
                      ),
                      TextButton(
                        onPressed: () {
                          supplierController.deleteSupplier(widget.supplier.id.toString());
                          Navigator.of(context).pop(); 
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("${widget.supplier.name} eliminado")),
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
      icon: const Icon(Icons.edit, color: Colors.black, size: 50),
      onPressed: () async {
        String? profilePhotoUrl = widget.supplier.urlProfilePhoto; 
        
        if (_image != null) {
          profilePhotoUrl = await storageController.uploadImage(File(_image!.path));
          print(profilePhotoUrl);
        }

        
        Supplier updatedSupplier = Supplier(
          id: widget.supplier.id,
          name: _nameController.text,
          phone: _phoneController.text,
          gmail: _gmailController.text,
          webSite: _webSiteController.text,
          address: _addressController.text,
          nit: _nitController.text,
          urlProfilePhoto: profilePhotoUrl, 
        );

       
        await supplierController.updateSupplier(updatedSupplier);

        Navigator.of(context).pop(); 
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${updatedSupplier.name} actualizado")),
        );
      },
    );
  }

}
