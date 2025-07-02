// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8000';

  // GET
  static Future<List<dynamic>> getData(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al cargar datos: ${response.statusCode}');
    }
  }

  // POST / PUT
  static Future<void> postData(String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Error al guardar: ${response.statusCode}');
    }
  }

  // DELETE
  static Future<void> deleteData(String endpoint, int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$endpoint$id'));
    if (response.statusCode != 204) {
      throw Exception('Error al eliminar: ${response.statusCode}');
    }
  }
}