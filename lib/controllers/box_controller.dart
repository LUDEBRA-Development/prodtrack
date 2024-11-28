import 'package:get/get.dart';
import 'package:prodtrack/models/Box.dart';
import 'package:prodtrack/services/box_service.dart';

class BoxController extends GetxController {
  final BoxService _boxService = BoxService();

  RxList<Box> boxes = <Box>[].obs;
  RxList<Box> filteredBoxes = <Box>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBoxes();
  }

  void fetchBoxes() async {
    isLoading.value = true;
    try {
      boxes.value = await _boxService.getAllBoxes();
      boxes.sort((a, b) => a.name.compareTo(b.name));
      filteredBoxes.value = boxes;
    } catch (e) {
      Get.snackbar('Error', 'No se pudieron cargar las cajas');
    } finally {
      isLoading.value = false;
    }
  }

  void filterBoxes(String query) {
    if (query.isEmpty) {
      filteredBoxes.value = boxes;
    } else {
      filteredBoxes.value = boxes.where((box) {
        return box.name.toLowerCase().contains(query.toLowerCase()) ||
            (box.price?.toString() ?? "").contains(query.toLowerCase());
      }).toList();
    }
  }

  Future<void> addBox(Box box) async {
    try {
      isLoading.value = true;
      final String boxId =
          await _boxService.saveBox(box); // Ahora retorna el ID
      box.id = boxId; // Asignar el ID al objeto
      boxes.add(box); // Actualizar la lista local
      Get.snackbar('Éxito', 'Caja guardada correctamente');
      Get.back(); // Volver a la vista anterior
    } catch (e) {
      Get.snackbar('Error', 'No se pudo guardar la caja: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateBox(Box box) async {
    await _boxService.updateBox(box);
    int index = boxes.indexWhere((b) => b.id == box.id);
    if (index != -1) {
      boxes[index] = box;
    }
  }

  Future<void> deleteBox(String boxId) async {
    try {
      await _boxService.deleteBox(boxId);
      boxes.removeWhere((box) => box.id == boxId);
    } catch (e) {
      Get.snackbar('Error', 'No se pudo eliminar la caja');
    }
  }
}
