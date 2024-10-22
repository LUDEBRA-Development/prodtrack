import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prodtrack/models/Ingredient.dart';

class IngredientsService {
  final String ingredientCollection = "ingredients";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveIngredient(Ingredient ingredient) async {
    DocumentReference docRef = await _firestore
        .collection(ingredientCollection)
        .add(ingredient.toMap());
    ingredient.id = docRef.id;
  }

  // Leer (Obtener) todos los proveedores
  Future<List<Ingredient>> getAllIngredients() async {
    QuerySnapshot snapshot =
        await _firestore.collection(ingredientCollection).get();
    return snapshot.docs.map((doc) => Ingredient.fromDocument(doc)).toList();
  }

  // Obtener un proveedor por ID
  Future<Ingredient?> getIngredientById(String id) async {
    DocumentSnapshot doc =
        await _firestore.collection(ingredientCollection).doc(id).get();
    if (doc.exists) {
      return Ingredient.fromDocument(doc);
    }
    return null; // Si no existe, retornar null
  }

  // Buscar proveedores por nombre
  Future<List<Ingredient>> searchIngredientByName(String name) async {
    QuerySnapshot snapshot = await _firestore
        .collection(ingredientCollection)
        .where('name', isEqualTo: name)
        .get();
    return snapshot.docs.map((doc) => Ingredient.fromDocument(doc)).toList();
  }

  // Buscar proveedores por cualquier campo
  Future<List<Ingredient>> searchIngredients(String field, String value) async {
    QuerySnapshot snapshot = await _firestore
        .collection(ingredientCollection)
        .where(field, isEqualTo: value)
        .get();
    return snapshot.docs.map((doc) => Ingredient.fromDocument(doc)).toList();
  }

  // Actualizar un proveedor
  Future<void> updateIngredient(Ingredient ingredient) async {
    await _firestore
        .collection(ingredientCollection)
        .doc(ingredient.id)
        .update(ingredient.toMap());
  }

  // Eliminar un proveedor
  Future<void> deleteIngredient(String id) async {
    await _firestore.collection(ingredientCollection).doc(id).delete();
  }
}
