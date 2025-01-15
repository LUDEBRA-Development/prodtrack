import 'package:flutter/material.dart';
import 'package:prodtrack/pages/employee/employe_home.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:prodtrack/pages/user_page/user_pages.dart';



class indexPagesEmployee extends StatefulWidget {
  indexPagesEmployee({super.key});

  @override
  State<indexPagesEmployee> createState() => _indexPagesEmployeeState();
}

class _indexPagesEmployeeState extends State<indexPagesEmployee> {
  int _selectedIndex = 0;

  // Define las páginas aquí sin necesidad de contexto
 final   List<Widget> _pages = <Widget>[ EmployeeHomePage(), UserPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const  Color.fromARGB(255, 241, 241, 241), // Fondo detrás de la barra de navegación
        buttonBackgroundColor: const Color.fromRGBO(255, 212, 0, 1), // Fondo del botón activo
        color: const Color.fromARGB(255, 255, 255, 255), // Color de la barra de navegación
        animationDuration: const Duration(milliseconds: 300), // Ajuste del tiempo de animación
        animationCurve: Curves.easeInOut, // Añadir curva de animación suave
        height: 70, // Ajustar la altura del navbar para dar más espacio

        items: [
          // Home Icon with Text for non-selected
          _buildNavItem(Icons.home, 'Home', 0),
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
