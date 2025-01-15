import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prodtrack/controllers/account_Payable_controller.dart';
import 'package:prodtrack/controllers/user_controller.dart';
import 'package:prodtrack/models/Activity.dart';
import 'package:prodtrack/pages/login_page.dart';
import 'package:prodtrack/services/firebase_service.dart';

class EmployeeHomePage extends StatelessWidget {
  final UserController userController = Get.put(UserController());
  final AccountPayableController accountPayableController = Get.put(AccountPayableController());
  final FirebaseService _firebaseService = FirebaseService();

  // Cambiar amountTotal a una variable reactiva con el tipo RxDouble
  RxDouble amountTotal = 0.0.obs;  // Se declara como RxDouble

  EmployeeHomePage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 241, 241),
      appBar: AppBar(
        title: const Text('Bienvenido'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text(
                'Menú de navegación',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: () async {
                await _firebaseService.signOut();
                Get.offAll(() => LoginPage());
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (userController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // Obtenemos los datos del usuario
          final user = userController.user.value;
          if (user == null) {
            return const Center(
              child: Text('No se encontró información del usuario'),
            );
          }
          accountPayableController.fetchIdAccountsPayable(user.id);
          amountTotal.value = 0.0;  
          for (var i = 0; i < accountPayableController.filteredAccountsPayable.length; i++) {
            final accountPayable = accountPayableController.filteredAccountsPayable[i];
            if (accountPayable != null) {
              amountTotal.value += accountPayable.amount;  
            }
          }

          // Renderizamos la información del usuario
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Foto de perfil
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                backgroundImage:
                    user.photoUrl != null && user.photoUrl!.isNotEmpty
                        ? NetworkImage(user.photoUrl!)
                        : null,
                child: user.photoUrl == null || user.photoUrl!.isEmpty
                    ? const Icon(Icons.person, size: 60, color: Colors.black)
                    : null,
              ),
                const SizedBox(height: 20),
                // Nombre del empleado
                Text(
                  'Hola, ${user.name}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                // Cantidad de dinero que se le debe
                Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Text(
                          'Dinero que se te debe:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 10),
                        Obx(() => Text(
                          '\$${amountTotal.value.toStringAsFixed(2)}',  // Mostrar el monto total con dos decimales
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                ElevatedButton(
                onPressed: () {
                  final accountPayable = accountPayableController.filteredAccountsPayable[0];
                  List<Activity> activities = accountPayable.activity;
                    showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView.builder(
                          itemCount: activities.length,  // Número de actividades
                          itemBuilder: (context, index) {
                            Activity activity = activities[index];  // Obtener la actividad correspondiente
                            return Card(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Detalles de la Cuenta por Pagar',
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 16),
                                    // Día de la semana
                                    Text(
                                      'Día de la semana: ${getSpanishDay(activity.dateTime)}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 8),
                                    // Producto
                                    Text(
                                      'Producto: ${activity.productName}',
                                      style:const  TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 8),
                                    // Cantidad
                                    Text(
                                      'Cantidad: ${activity.quantity}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 8),
                                    // Empleados
                                    Text(
                                      'Empleados: ${activity.employees.map((e) => e.name).join(", ")}',
                                      style: const  TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },

                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Text('Ver más detalles'),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  String getSpanishDay(DateTime dateTime) {
  // Lista de los días de la semana en español
  List<String> diasDeLaSemana = [
    'lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo'
  ];

  // Obtener el índice del día de la semana
  int diaIndex = dateTime.weekday - 1; // weekday devuelve un valor entre 1 (lunes) y 7 (domingo)

  // Retornar el día en español
  return diasDeLaSemana[diaIndex];
}

}
