import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prodtrack/pages/register_page.dart';
import 'package:prodtrack/widgets/text_editing_controller.dart';
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
                const SizedBox(height: 30),
                // Logo de la app como imagen completa (no ovalada)
                Image.asset(
                  'assets/images/iconoProdTrack-removebg-preview.png',
                  height: 120, // Ajusta el tamaño del logo como necesites
                ),
                const SizedBox(height: 20),
                // Texto del nombre de la app
                const Text(
                  'PODTRACK',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                // Texto "Iniciar sesión"
                const Text(
                  'Iniciar sesión',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.normal,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 40),
                // Campo de correo
                CustomTextField(
                  hintText: 'Correo',
                  controller: _emailController,
                ),
                const SizedBox(height: 20),
                // Campo de contraseña
                CustomTextField(
                  hintText: 'Contraseña',
                  controller: _passwordController,
                  isPassword: true,
                ),
                const SizedBox(height: 40),
                // Botón de inicio de sesión
                Obx(() => _authController.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : _buildLoginButton(context)),
                const SizedBox(height: 20),
                // Texto para redirigir a registro
                Center(
                  child: GestureDetector(
                    onTap: () =>
                        Get.to(() => RegisterPage()), // Redirige a registro
                    child: RichText(
                      text: const TextSpan(
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



  Widget _buildLoginButton(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const  EdgeInsets.symmetric(vertical: 16),
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
          child: const  Text(
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
