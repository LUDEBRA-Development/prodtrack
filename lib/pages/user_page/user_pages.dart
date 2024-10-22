import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prodtrack/pages/user_page/user_edit_pages.dart';
import 'package:prodtrack/controllers/user_controller.dart';

class UserPage extends StatelessWidget {
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFdcdcdc),
      appBar: AppBar(
        backgroundColor: const Color(0xFFdcdcdc),
        title: const Text(
          "Información del Usuario",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Mostrar opciones para editar
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Opciones'),
                  content:
                      const Text('¿Desea editar la información del usuario?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Cerrar diálogo
                        // Asegurarte de que el usuario no es nulo
                        if (userController.user.value != null) {
                          // Navegar a la página de edición
                          Get.to(() => UserEditPage(
                              user: userController.user
                                  .value!)); // Agrega el operador ! para asegurar que no es nulo
                        } else {
                          // Manejar el caso donde no hay usuario
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('No se pudo encontrar al usuario')),
                          );
                        }
                      },
                      child: const Text('Editar'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Cerrar diálogo
                      },
                      child: const Text('Cancelar'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (userController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = userController.user.value;
          if (user == null) {
            return const Center(
                child: Text('No se encontró información del usuario'));
          }

          return Column(
            children: [
              // Mostrar imagen de usuario
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                backgroundImage: NetworkImage(user.photoUrl ??
                    ''), // Asegúrate de que photoUrl esté definido
              ),
              const SizedBox(height: 20),
              _buildInfoField('Nombre', user.name),
              _buildInfoField('Apellido', user.lastName),
              _buildInfoField('Email', user.email),
              _buildInfoField('Teléfono', user.phone ?? 'No disponible'),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildInfoField(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xFFcbcbcb),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(value),
          ],
        ),
      ),
    );
  }
}
