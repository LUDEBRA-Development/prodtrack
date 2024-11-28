import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prodtrack/controllers/box_controller.dart';
import 'package:prodtrack/models/Box.dart';

class ModifyBoxPage extends StatefulWidget {
  final Box box;

  const ModifyBoxPage({super.key, required this.box});

  @override
  State<ModifyBoxPage> createState() => _ModifyBoxPageState();
}

class _ModifyBoxPageState extends State<ModifyBoxPage> {
  final BoxController boxController = Get.put(BoxController());

  // Controladores para los campos del formulario
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController abilityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inicializar los controladores con los datos de la caja
    nameController.text = widget.box.name;
    priceController.text = widget.box.price?.toString() ?? '';
    quantityController.text = widget.box.quantity.toString();
    abilityController.text = widget.box.ability?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modificar Caja'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteBox,
          ),
        ],
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
                onPressed: _updateBox,
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

  void _updateBox() {
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

    final updatedBox = Box(
      widget.box.id,
      name,
      price,
      quantity,
      ability,
    );

    boxController.updateBox(updatedBox).then((_) {
      Get.snackbar('Éxito', 'Caja actualizada correctamente');
      Get.back(); // Regresar a la pantalla anterior
    }).catchError((error) {
      Get.snackbar('Error', 'Hubo un problema al actualizar la caja');
    });
  }

  void _deleteBox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text('¿Está seguro de que desea eliminar esta caja?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                boxController.deleteBox(widget.box.id).then((_) {
                  Navigator.of(context).pop(); // Cerrar el diálogo
                  Navigator.of(context).pop(); // Volver a la pantalla anterior
                  Get.snackbar('Éxito', 'Caja eliminada correctamente');
                }).catchError((error) {
                  Navigator.of(context).pop();
                  Get.snackbar('Error', 'Hubo un problema al eliminar la caja');
                });
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}
