// class Und {
//   final String id;
//   final String name;
//   final int value;

//   Und(this.name, this.id, this.value);

//   // Método toMap para convertir a un mapa
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'value': value,
//     };
//   }

//   // Factory constructor fromMap para convertir desde un mapa
//   factory Und.fromMap(Map<String, dynamic> map) {
//     return Und(
//       map['name'],
//       map['id'],
//       map['value'],
//     );
//   }
// }

class Und {
  String id;
  String name;
  double value;

  Und(this.id, this.name, this.value);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'value': value,
    };
  }

  factory Und.fromMap(Map<String, dynamic> map) {
    return Und(
      map['id'] ?? '',
      map['name'] ?? '',
      (map['value'] as num).toDouble(),
    );
  }
}
