import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prodtrack/pages/ingredients_page/ingredients_page.dart';
import 'package:prodtrack/pages/login_page.dart';
import 'package:prodtrack/pages/product_page/product_page.dart';
import 'package:prodtrack/pages/report_pages/account_payable/accounts_payable.dart';
import 'package:prodtrack/pages/report_pages/price_product/price_product_report.dart';
import 'package:prodtrack/services/firebase_service.dart';
import 'package:prodtrack/pages/supplier_pages/supplier_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userName;
  bool isLoading = true;
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    String? name = await _firebaseService.getUserName();
    setState(() {
      userName = name;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 241, 241),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text('PRODTRACK'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Acción para la campana
            },
          ),
        ],
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
            ListTile(
              title: const Text('Inventario'),
              onTap: () {
                Get.to(() => Scaffold(
                      appBar: AppBar(
                        backgroundColor: Colors.white,
                        title: const Text("Inventario"),
                      ),
                      body: const PriceProductReport(),
                    ));
              },
            ),
            ListTile(
              title: const Text('Gestión financiera'),
              onTap: () {
                Get.to(() => Scaffold(
                      appBar: AppBar(
                        backgroundColor: Colors.white,
                        title: const Text("Gestión de finanzas"),
                      ),
                      body: const AccountsPayableView(),
                    ));
              },
            ),
            ListTile(
              title: const Text('Gestión de usuarios'),
              onTap: () {
                Get.snackbar("Error", "Próximamente, función en desarrollo");
              },
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
        padding: const EdgeInsets.only(top: 20.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Container(
                width: double.infinity,
                height: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Encabezado con saludo
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[300],
                          child: const Icon(Icons.person, size: 50),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName != null ? 'Hola,\n$userName' : 'Hola',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Bendito sea Jehová, mi roca,\nquien adiestra mis manos\npara la batalla, y mis dedos\npara la guerra.\n\nSalmo 144:1',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20), // Espacio entre encabezado y botones
        
                    // Contenedor de botones con desplazamiento
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Primera fila de botones
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                menuButton(
                                  context,
                                  'INVENTARIO',
                                  Icons.warehouse,
                                  Colors.blue,
                                  const ProductView(),
                                ),
                                menuButton(
                                  context,
                                  'INGREDIENTES',
                                  Icons.filter_alt,
                                  Colors.green,
                                  IngredientsPage(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10), // Espacio entre filas
        
                            // Segunda fila de botones
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                menuButton(
                                  context,
                                  'PROVEEDORES',
                                  Icons.business,
                                  Colors.orange,
                                  const SupplierView(),
                                ),
                                menuButton(
                                  context,
                                  'FACTURAS',
                                  Icons.receipt,
                                  Colors.red,
                                  const SupplierView(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  // Widget para los botones del menú
  Widget menuButton(BuildContext context, String title, IconData icon,
      Color color, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => page,
          ),
        );
      },
      child: Card(
        color: color,
        child: SizedBox(
          width: 150,
          height: 170,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.white),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
