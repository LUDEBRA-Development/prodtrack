import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prodtrack/controllers/user_controller.dart';
import 'package:prodtrack/models/user_model.dart';
import 'dart:io';

class UserEditPage extends StatefulWidget {
  final UserModel user; // Usuario a modificar

  const UserEditPage({super.key, required this.user});

  @override
  State<UserEditPage> createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  final UserController userController = Get.put(UserController());
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  @override
  void initState() {
    super.initState();
    // Inicializar los controladores con los datos del usuario
    _nameController.text = widget.user.name;
    _lastNameController.text = widget.user.lastName;
    _emailController.text = widget.user.email;
    _phoneController.text = widget.user.phone ?? '';
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
          "Modificar Usuario",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          bottomUpdate(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Botón para agregar foto
            image(),
            const SizedBox(height: 30),
            _buildTextField(_nameController, "Nombre", Icons.person),
            _buildTextField(_lastNameController, "Apellido", Icons.person),
            _buildTextField(_emailController, "Email", Icons.email),
            _buildTextField(_phoneController, "Teléfono", Icons.phone),
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

  Widget bottomUpdate() {
    return IconButton(
      icon: const Icon(Icons.edit, color: Colors.black, size: 50),
      onPressed: () async {
        UserModel updatedUser = UserModel(
          id: widget.user.id,
          name: _nameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          // Aquí puedes agregar la lógica para manejar la imagen si es necesario
        );
        await userController.updateUser(updatedUser);
        Navigator.of(context).pop(); // Volver a la vista anterior
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${updatedUser.name} actualizado")),
        );
      },
    );
  }
}
