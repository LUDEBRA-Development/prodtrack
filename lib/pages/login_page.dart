import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prodtrack/pages/register_page.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                // Logo de la app como imagen completa (no ovalada)
                Image.asset(
                  'assets/images/iconoProdTrack-removebg-preview.png',
                  height: 120, // Ajusta el tamaño del logo como necesites
                ),
                SizedBox(height: 20),
                // Texto del nombre de la app
                Text(
                  'PODTRACK',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                // Texto "Iniciar sesión"
                Text(
                  'Iniciar sesión',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.normal,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 40),
                // Campo de correo
                _buildTextField(context, 'Correo', _emailController),
                SizedBox(height: 20),
                // Campo de contraseña
                _buildTextField(context, 'Contraseña', _passwordController,
                    obscureText: true),
                SizedBox(height: 40),
                // Botón de inicio de sesión
                Obx(() => _authController.isLoading.value
                    ? Center(child: CircularProgressIndicator())
                    : _buildLoginButton(context)),
                SizedBox(height: 20),
                // Texto para redirigir a registro
                Center(
                  child: GestureDetector(
                    onTap: () =>
                        Get.to(() => RegisterPage()), // Redirige a registro
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(text: '¿No estás registrado? '),
                          TextSpan(
                            text: 'Regístrate',
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
        labelStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
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
            String email = _emailController.text.trim();
            String password = _passwordController.text.trim();

            _authController.login(email, password);
          },
          child: Text(
            'Iniciar Sesión',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
