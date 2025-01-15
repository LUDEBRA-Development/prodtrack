import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prodtrack/models/account_payable.dart';

class AccountPayableService {
  final String accountPayableCollection = "account_payables";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Agregar una nueva cuenta por pagar
Future<void> saveAccountPayable(AccountPayable accountPayable) async {
  // Obtén todas las cuentas por pagar para el beneficiario
  QuerySnapshot snapshot = await _firestore.collection(accountPayableCollection)
      .where('beneficiary.id', isEqualTo: accountPayable.beneficiary.id) // Asegúrate de que el Beneficiary tenga un ID
      .get();

  if (snapshot.docs.isNotEmpty) {
    // Si ya existe una cuenta por pagar para este beneficiario
    DocumentSnapshot existingDoc = snapshot.docs.first;

    // Verifica si la cuenta está pagada
    if (existingDoc['isPaid'] == false) {
      // Si no está pagada, actualiza el monto
      double existingAmount = existingDoc['amount'];
      DocumentReference docRef = existingDoc.reference;

      // Obtén las actividades existentes
      List<dynamic> existingActivities = existingDoc['activity'] ?? [];

      // Añadir la nueva actividad a las actividades existentes
      existingActivities.addAll(accountPayable.activity.map((activity) => activity.toMap()));

      // Actualiza el monto y las actividades
      await docRef.update({
        'amount': existingAmount + accountPayable.amount,
        'activity': existingActivities,
      });
    } else {
      // Si la cuenta ya está pagada, crea una nueva cuenta por pagar
      DocumentReference docRef = await _firestore.collection(accountPayableCollection).add(accountPayable.toMap());
      accountPayable.id = docRef.id; 
    }
  } else {
    // Si no existe, crea una nueva cuenta por pagar
    DocumentReference docRef = await _firestore.collection(accountPayableCollection).add(accountPayable.toMap());
    accountPayable.id = docRef.id;
  }
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
