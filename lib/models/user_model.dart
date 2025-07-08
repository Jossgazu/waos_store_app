class User {
  final int id;
  final String nombre;
  final String dni;
  final String correo;
  final String rol;

  User({
    required this.id,
    required this.nombre,
    required this.dni,
    required this.correo,
    required this.rol,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id_usuario'],
      nombre: json['nombre'],
      dni: json['dni'],
      correo: json['correo'],
      rol: json['rol'],
    );
  }
}