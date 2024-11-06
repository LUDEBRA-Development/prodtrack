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
 final   List<Widget> _pages = <Widget>[HomePage(), ReportPage(), UserPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const  Color.fromARGB(255, 241, 241, 241), // Fondo detrás de la barra de navegación
        buttonBackgroundColor: const Color(0xFFFFD400), // Fondo del botón activo
        color: const Color.fromARGB(255, 255, 255, 255), // Color de la barra de navegación
        animationDuration: const Duration(milliseconds: 300), // Ajuste del tiempo de animación
        animationCurve: Curves.easeInOut, // Añadir curva de animación suave
        height: 70, // Ajustar la altura del navbar para dar más espacio

        items: [
          // Home Icon with Text for non-selected
          _buildNavItem(Icons.home, 'Home', 0),
          // Report Icon with Text for non-selected
          _buildNavItem(Icons.insert_chart, 'Reportes', 1),
          // User Icon with Text for non-selected
          _buildNavItem(Icons.person, 'User', 2),
        ],

        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  // Widget helper to build navigation items
  Widget _buildNavItem(IconData icon, String label, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 30, color: _selectedIndex == index ? Colors.black : Colors.black),
        if (_selectedIndex != index)
          Text(
            label,
            style: const TextStyle(color: Colors.black, fontSize: 12),
          ),
      ],
    );
  }
}
