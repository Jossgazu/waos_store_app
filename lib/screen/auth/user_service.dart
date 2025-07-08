import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static const String _baseUrl = 'http://localhost:8000/usuario';

  // Ahora el token se pasa como argumento
  static Future<Map<String, dynamic>> getCurrentUser(String token) async {
    try {
      if (token == null || token.isEmpty) throw Exception('No autenticado');

      final response = await http.get(
        Uri.parse('$_baseUrl/me'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al obtener usuario: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en UserService.getCurrentUser: $e');
    }
  }

  static Future<Map<String, dynamic>> getUserByDni(String dni, String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/dni/$dni'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener usuario por DNI');
    }
  }

  static Future<List<dynamic>> getUsersByRole(String rol, String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/rol/$rol'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener usuarios por rol');
    }
  }
}