import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prodtrack/controllers/box_controller.dart';
import 'package:prodtrack/models/Box.dart';

class AddBoxPage extends StatelessWidget {
  final BoxController boxController = Get.find<BoxController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController abilityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Caja'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              controller: nameController,
              label: 'Nombre',
              hint: 'Ingrese el nombre de la caja',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: priceController,
              label: 'Precio',
              hint: 'Ingrese el precio',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: quantityController,
              label: 'Cantidad',
              hint: 'Ingrese la cantidad disponible',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: abilityController,
              label: 'Capacidad',
              hint: 'Ingrese la capacidad (opcional)',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addBox,
                child: const Text('Guardar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  void _addBox() {
    final name = nameController.text.trim();
    final price = double.tryParse(priceController.text.trim());
    final quantity = int.tryParse(quantityController.text.trim());
    final ability = int.tryParse(abilityController.text.trim());

    if (name.isEmpty) {
      Get.snackbar('Error', 'El nombre no puede estar vacío');
      return;
    }

    if (price == null || price <= 0) {
      Get.snackbar('Error', 'El precio debe ser mayor a 0');
      return;
    }

    if (quantity == null || quantity < 0) {
      Get.snackbar('Error', 'La cantidad debe ser mayor o igual a 0');
      return;
    }

    final box = Box(
      '', // El ID será asignado en Firestore
      name,
      price,
      quantity,
      ability,
    );

    boxController.addBox(box).then((_) {
      Get.snackbar('Éxito', 'Caja guardada correctamente');
      Get.back(); // Regresar a la pantalla anterior
    }).catchError((error) {
      Get.snackbar('Error', 'Hubo un problema al guardar la caja');
    });
  }
}
