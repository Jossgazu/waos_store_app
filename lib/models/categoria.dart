// // lib/models/categoria.dart

// class Categoria {
//   final int id;
//   final String nombre;
//   final String descripcion;
//   final bool activo;

//   Categoria({
//     required this.id,
//     required this.nombre,
//     required this.descripcion,
//     required this.activo,
//   });

//   factory Categoria.fromMap(Map<String, dynamic> map) {
//     return Categoria(
//       id: map['id_categoria'],
//       nombre: map['nombre'],
//       descripcion: map['descripcion'],
//       activo: map['activo'] is int ? map['activo'] == 1 : map['activo'],
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'nombre': nombre,
//       'descripcion': descripcion,
//       'activo': activo ? 1 : 0,
//     };
//   }
// }