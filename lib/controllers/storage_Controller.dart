import 'dart:io';
import 'package:get/get.dart';
import 'package:prodtrack/services/storage_services.dart';

class StorageController extends GetxController {
  final StorageService _storageService = StorageService();

  Future<String?> uploadImage(File image) async {
    try {
      String? imageUrl = await _storageService.uploadImage(image);
      if (imageUrl != null) {
        Get.snackbar('Éxito', 'Imagen subida correctamente');
      }
      return imageUrl;
    } catch (e) {
  
      Get.snackbar('Error', 'No se pudo subir la imagen');
      return null;
    }
  }
}
