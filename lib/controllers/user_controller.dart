import 'package:get/get.dart';
import 'package:prodtrack/models/user_model.dart';
import 'package:prodtrack/services/user_services.dart';

class UserController extends GetxController {
  final UserService _userService = UserService();

  // Variable observable para el usuario
  Rx<UserModel?> user = Rx<UserModel?>(null);

  // Estado de carga
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUser(); // Cargar el usuario al inicializar el controlador
  }

  // Obtener información del usuario
  Future<void> fetchUser() async {
    try {
      isLoading.value = true;
      String? uid = _userService.currentUser?.uid;
      if (uid != null) {
        user.value = await _userService.getUserById(uid);
      }
    } catch (e) {
      Get.snackbar('Error', 'No se pudo cargar la información del usuario');
    } finally {
      isLoading.value = false;
    }
  }

  // Actualizar la información del usuario
  Future<void> updateUser(UserModel updatedUser) async {
    try {
      await _userService.updateUser(updatedUser);
      user.value = updatedUser; // Actualizar el usuario en el controlador
      Get.snackbar('Éxito', 'Información actualizada correctamente');
    } catch (e) {
      Get.snackbar('Error', 'No se pudo actualizar la información');
    }
  }
}
