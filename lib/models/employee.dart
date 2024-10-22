class Employee {
  final int id;
  final String name;
  final String? urlProfilePhoto;


  Employee({
    required this.id,
    required this.name,
    this.urlProfilePhoto,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'urlProfilePhoto': urlProfilePhoto,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      urlProfilePhoto: map['urlProfilePhoto'],
    );
  }
}