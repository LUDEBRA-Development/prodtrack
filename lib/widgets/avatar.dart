import 'package:flutter/material.dart';

Widget avatar(String name) {
  // Lista de colores asignados por rango
  Map<String, String> colorRanges = {
    "A-D": "F56217", // Naranja
    "E-H": "F5CC17", // Amarillo
    "I-L": "00875E", // Verde oscuro
    "M-P": "04394E", // Azul oscuro
    "Q-T": "9C27B0", // Púrpura
    "U-Z": "E91E63", // Rosa
  };

  // Función para convertir el color hex a un objeto Color
  Color getColorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll("#", "");
    return Color(int.parse("FF$hexCode", radix: 16));
  }

  // Determinar el rango de la letra
  String firstLetter = name.isNotEmpty ? name[0].toUpperCase() : 'A';
  String assignedColorHex = "FFFFFF"; // Color por defecto (blanco)
  for (var range in colorRanges.keys) {
    // Separar los rangos en letras iniciales y finales
    List<String> bounds = range.split("-");
    if (bounds.length == 2 &&
        firstLetter.compareTo(bounds[0]) >= 0 &&
        firstLetter.compareTo(bounds[1]) <= 0) {
      assignedColorHex = colorRanges[range]!;
      break;
    }
  }

  // Retornar el avatar circular con el color y la inicial
  return CircleAvatar(
    backgroundColor: getColorFromHex(assignedColorHex),
    radius: 30,
    child: Text(
      firstLetter,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 32,
      ),
    ),
  );
}
