import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class RegisterPage extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());

  // Controladores para los nuevos campos
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                Center(
                  child: Text(
                    'Registrarse',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                _buildTextField(context, 'Nombre', _nameController),
                SizedBox(height: 20),
                _buildTextField(context, 'Apellido', _lastNameController),
                SizedBox(height: 20),
                _buildTextField(context, 'Identificación', _idController),
                SizedBox(height: 20),
                _buildTextField(context, 'Correo', _emailController),
                SizedBox(height: 20),
                _buildTextField(context, 'Contraseña', _passwordController,
                    obscureText: true),
                SizedBox(height: 40),
                Obx(() => _authController.isLoading.value
                    ? Center(child: CircularProgressIndicator())
                    : _buildRegisterButton(context)),
                SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(text: '¿Ya tienes una cuenta? '),
                          TextSpan(
                            text: 'Inicia Sesión',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      BuildContext context, String hintText, TextEditingController controller,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: TextStyle(
          color: Colors.grey,
          shadows: [
            Shadow(
              offset: Offset(1, 1),
              blurRadius: 1.0,
              color: Colors.black.withOpacity(0.3),
            ),
          ],
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: Colors.grey[700],
          ),
          onPressed: () {
            String name = _nameController.text.trim();
            String lastName = _lastNameController.text.trim();
            String id = _idController.text.trim();
            String email = _emailController.text.trim();
            String password = _passwordController.text.trim();

            _authController.register(email, password, name, lastName, id);
          },
          child: Text(
            'Registrarse',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              shadows: [
                Shadow(
                  offset: Offset(1, 1),
                  blurRadius: 1.0,
                  color: Colors.black.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
