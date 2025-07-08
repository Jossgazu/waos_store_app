import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AuthService {
  static const String _baseUrl = 'http://localhost:8000';
  static const String _loginEndpoint = '/usuario/token';

  static Future<Map<String, dynamic>> login(String dni, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$_loginEndpoint'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {
          'username': dni,
          'password': password,
        },
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        // Verifica que la respuesta contenga los campos esperados
        if (responseData['access_token'] == null || responseData['token_type'] == null) {
          throw Exception('La respuesta del servidor no contiene los datos esperados');
        }

        return responseData;
      } else {
        // Intenta parsear el mensaje de error del backend
        final errorResponse = json.decode(response.body);
        throw Exception(errorResponse['detail'] ?? 'Error de autenticación');
      }
    } catch (e) {
      debugPrint('Error en AuthService.login: $e');
      rethrow;
    }
  }
  // Función para registro
  static Future<Map<String, dynamic>> register(
      String dni, String email, String password, String nombre) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'dni': dni,
          'correo': email,
          'password': password,
          'nombre': nombre,
          'rol': 'cliente', // Rol por defecto para nuevos usuarios
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Error en el registro: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al conectar con el servidor: $e');
    }
  }
}