import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prodtrack/pages/register_page.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());

  final TextEditingController _emailController =
      TextEditingController(); //no se inicia sesion con usermane sino con email xd
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
                    'Iniciar Sesión',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                _buildTextField(context, 'Correo', _emailController),
                SizedBox(height: 20),
                _buildTextField(context, 'Contraseña', _passwordController,
                    obscureText: true),
                SizedBox(height: 40),
                Obx(() => _authController.isLoading.value
                    ? Center(child: CircularProgressIndicator())
                    : _buildLoginButton(context)),
                SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: () => Get.to(() =>
                        RegisterPage()), // Redirige a la página de registro
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
            String username = _emailController.text.trim();
            String password = _passwordController.text.trim();

            _authController.login(username, password);
          },
          child: Text(
            'Iniciar Sesión',
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
