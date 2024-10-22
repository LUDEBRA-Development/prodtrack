import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prodtrack/models/account_payable.dart';

class AccountPayableService {
  final String accountPayableCollection = "account_payables";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Agregar una nueva cuenta por pagar
  Future<void> saveAccountPayable(AccountPayable accountPayable) async {
    DocumentReference docRef = await _firestore.collection(accountPayableCollection).add(accountPayable.toMap());
    accountPayable.id = docRef.id;
  }

  // Leer (Obtener) todas las cuentas por pagar
  Future<List<AccountPayable>> getAllAccountPayables() async {
    QuerySnapshot snapshot = await _firestore.collection(accountPayableCollection).get();
    return snapshot.docs.map((doc) => AccountPayable.fromDocument(doc)).toList();
  }




  // Obtener una cuenta por pagar por ID
  Future<AccountPayable?> getAccountPayableById(String id) async {
    DocumentSnapshot doc = await _firestore.collection(accountPayableCollection).doc(id).get();
    if (doc.exists) {
      return AccountPayable.fromDocument(doc);
    }
    return null;  // Si no existe, retornar null
  }

  // Actualizar una cuenta por pagar
  Future<void> updateAccountPayable(AccountPayable accountPayable) async {
    await _firestore.collection(accountPayableCollection).doc(accountPayable.id.toString()).update(accountPayable.toMap());
  }

  // Eliminar una cuenta por pagar
  Future<void> deleteAccountPayable(String id) async {
    print("Esta es la id"+id);
    await _firestore.collection(accountPayableCollection).doc(id).delete();
  }
}
