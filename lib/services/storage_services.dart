import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage
import 'package:image_picker/image_picker.dart'; // Para seleccionar imágenes

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  // Función para seleccionar imagen desde galería
  Future<File?> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      return File(pickedFile.path); // Retornar archivo
    } else {
      return null; // Si no se selecciona ninguna imagen
    }
  }

  // Función para subir imagen a Firebase Storage
  Future<String?> uploadImage(File image) async {

      String fileName = 'uploads/${DateTime.now().millisecondsSinceEpoch}.png';
      
      Reference ref = _storage.ref().child(fileName);

      UploadTask uploadTask = ref.putFile(image);

      TaskSnapshot snapshot = await uploadTask;

      // Obtener la URL de descarga
      String downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
  }
}
