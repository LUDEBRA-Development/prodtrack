  
import 'package:flutter/material.dart';

// Función para crear un widget de barra de búsqueda
Widget searchBar(TextEditingController searchController, String textSearch) {
  return Container(
    height: 40,  // Altura del contenedor de la barra de búsqueda
    decoration: BoxDecoration(
      color: const Color(0xFFcbcbcb),  // Color de fondo de la barra
      borderRadius: BorderRadius.circular(15.0),  // Bordes redondeados
    ),
    child: TextField(
      controller: searchController,  // Controlador para gestionar el texto ingresado
      style: const TextStyle(color: Colors.black),  // Estilo del texto ingresado
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(bottom: 8),  // Ajuste del padding del contenido
        hintText: textSearch,  // Texto sugerido o placeholder
        hintStyle: const TextStyle(
          color: Color(0xFF787878),  // Color del texto sugerido
          fontSize: 17,  // Tamaño del texto sugerido
        ),
        border: InputBorder.none,  // Elimina la línea inferior por defecto
        icon: const Padding(
          padding: EdgeInsets.only(left: 10.0),  // Espacio entre el icono de búsqueda y el borde izquierdo
          child: Icon(
            Icons.search,  // Icono de lupa para la búsqueda
            color: Colors.black,  // Color del icono
          ),
        ),
      ),
    ),
  );
}
