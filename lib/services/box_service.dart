import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prodtrack/models/Box.dart';

class BoxService {
  final String boxCollection = "boxes";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Guardar una caja
  Future<String> saveBox(Box box) async {
    DocumentReference docRef =
        await _firestore.collection(boxCollection).add(box.toMap());
    return docRef.id; // Retornar el ID del documento creado
  }

  // Obtener todas las cajas
  Future<List<Box>> getAllBoxes() async {
    QuerySnapshot snapshot = await _firestore.collection(boxCollection).get();
    return snapshot.docs
        .map((doc) => Box.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Obtener una caja por ID
  Future<Box?> getBoxById(String id) async {
    DocumentSnapshot doc =
        await _firestore.collection(boxCollection).doc(id).get();
    if (doc.exists) {
      return Box.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Buscar cajas por nombre
  Future<List<Box>> searchBoxByName(String name) async {
    QuerySnapshot snapshot = await _firestore
        .collection(boxCollection)
        .where('name', isEqualTo: name)
        .get();
    return snapshot.docs
        .map((doc) => Box.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Actualizar una caja
  Future<void> updateBox(Box box) async {
    await _firestore.collection(boxCollection).doc(box.id).update(box.toMap());
  }

  // Eliminar una caja
  Future<void> deleteBox(String id) async {
    await _firestore.collection(boxCollection).doc(id).delete();
  }
}
