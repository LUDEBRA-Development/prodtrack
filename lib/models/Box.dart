class Box {
  String id;
  final String name;
  final double? price;
  final int quantity;
  final int? ability;

  Box(this.id, this.name, this.price, this.quantity, this.ability);

  // Método toMap
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'ability': ability,
    };
  }

  // Factory constructor fromMap
  factory Box.fromMap(Map<String, dynamic> map) {
    return Box(
      map['id'],
      map['name'],
      map['price'] is int ? (map['price'] as int).toDouble() : map['price'],
      map['quantity'],
      map['ability'],
    );
  }

}
