import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prodtrack/pages/index_pages.dart';
import 'firebase_options.dart';

void main() async {
  // Asegúrate de que los widgets se han inicializado antes de llamar a Firebase.
  WidgetsFlutterBinding.ensureInitialized();

  // Espera a que Firebase se inicialice antes de continuar.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Define el tamaño base de diseño (ajústalo a tus necesidades)
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: "Mi aplicación",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: indexPages(), // La página principal de tu aplicación.
        );
      },
    );
  }
}
