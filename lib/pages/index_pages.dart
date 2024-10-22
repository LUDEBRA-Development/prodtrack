import 'package:flutter/material.dart';
import 'package:prodtrack/pages/home_page.dart';
import 'package:prodtrack/pages/report_pages/report_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:prodtrack/pages/user_page/user_pages.dart';

class indexPages extends StatefulWidget {
  const indexPages({super.key});

  @override
  State<indexPages> createState() => _indexPagesState();
}

class _indexPagesState extends State<indexPages> {
  int _selectedIndex = 0;

  // Define las páginas aquí sin necesidad de contexto
  static List<Widget> _pages = <Widget>[HomePage(), ReportPage(), UserPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi app', style: TextStyle(fontSize: 20)),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor:
            const Color(0xFFdcdcdc), // Fondo detrás de la barra de navegación
        buttonBackgroundColor:
            const Color(0xFF939393), // Fondo del botón activo
        color: const Color(0xFF939393), // Color de la barra de navegación
        animationDuration:
            const Duration(milliseconds: 300), // Ajuste del tiempo de animación
        animationCurve: Curves.easeInOut, // Añadir curva de animación suave
        height: 60, // Ajustar la altura del navbar para dar más espacio

        items: const [
          Icon(Icons.home,
              size: 40,
              color: Colors.black), // Ajustar el tamaño y color del icono
          Icon(Icons.insert_chart, size: 40, color: Colors.black),
          Icon(Icons.person, size: 40, color: Colors.black),
        ],

        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

// Define el widget homePage sin necesidad de contexto
