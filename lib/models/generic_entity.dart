class GenericEntity {
  final int id;
  final Map<String, dynamic> data;

  GenericEntity({required this.id, required this.data});

  String get name => data['nombre'] ?? data['nombre_completo'] ?? 'Sin nombre';
}