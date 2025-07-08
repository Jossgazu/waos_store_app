import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  // static const String baseUrl = 'http://10.0.2.2:8000';
  static const String baseUrl = 'http://localhost:8000';
  
  // Método para obtener datos (GET)
  // ...existing code...
static Future<List<Map<String, dynamic>>> getData(String endpoint) async {
  try {
    // Limpiar endpoint y construir URL correcta
    String cleanEndpoint = endpoint.replaceAll(RegExp(r'^/+|/+$'), '');
    final url = '$baseUrl/$cleanEndpoint/';
    
    print('Getting data from URL: $url'); // Debug
    
    final response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    
    print('Response status: ${response.statusCode}'); // Debug
    print('Response body: ${response.body}'); // Debug
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.cast<Map<String, dynamic>>();
    } else if (response.statusCode == 404) {
      throw Exception(
        'Error 404 - Not Found: El endpoint "$url" no existe en el backend. '
        'Esto puede deberse a que:\n'
        '- El nombre del endpoint es incorrecto (revisa mayúsculas, guiones y barras).\n'
        '- El backend no tiene implementada la ruta solicitada.\n'
        '- Hay un error en la configuración de rutas del backend.\n'
        'Verifica que la URL sea correcta y que el backend esté corriendo.'
      );
    } else if (response.statusCode == 500) {
      throw Exception(
        'Error 500 - Internal Server Error: El servidor encontró un error al procesar la solicitud para "$url". '
        'Esto puede deberse a:\n'
        '- Un error en la lógica del backend (excepción no controlada).\n'
        '- Problemas de base de datos o dependencias.\n'
        '- El backend recibió datos inesperados o incompletos.\n'
        'Revisa los logs del backend para más detalles.'
      );
    } else {
      throw Exception(
        'Error del servidor: ${response.statusCode} - ${response.body}\n'
        'URL solicitada: $url'
      );
    }
  } catch (e) {
    print('Error in ApiService.getData: $e'); // Debug
    throw Exception('Error al obtener datos: $e');
  }
}

// ...existing code...

static Future<Map<String, dynamic>> getDataMap(String endpoint) async {
  try {
    String cleanEndpoint = endpoint.replaceAll(RegExp(r'^/+|/+$'), '');
    final url = '$baseUrl/$cleanEndpoint/';
    print('Getting data (map) from URL: $url');
    final response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Error del servidor: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    print('Error in ApiService.getDataMap: $e');
    throw Exception('Error al obtener datos: $e');
  }
}

  // Método para obtener un elemento específico por ID (GET)
  static Future<Map<String, dynamic>> getDataById(String endpoint, int id) async {
    try {
      String cleanEndpoint = endpoint.replaceAll('/', '');
      final url = '$baseUrl/$cleanEndpoint/$id/';
      
      print('Getting data by ID from URL: $url'); // Debug
      
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      
      print('Response status: ${response.statusCode}'); // Debug
      print('Response body: ${response.body}'); // Debug
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return json.decode(response.body);
      } else {
        throw Exception('Error del servidor: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in ApiService.getDataById: $e'); // Debug
      throw Exception('Error al obtener elemento: $e');
    }
  }

  // Método para eliminar datos (DELETE)
// Método para eliminar datos (DELETE)
static Future<void> deleteData(String endpoint, int id) async {
  try {
    String cleanEndpoint = endpoint.replaceAll('/', '');
    
    // Try without trailing slash first
    String url = '$baseUrl/$cleanEndpoint/$id';
    
    print('Deleting from URL: $url'); // Debug
    
    final response = await http.delete(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    
    print('Response status: ${response.statusCode}'); // Debug
    print('Response body: ${response.body}'); // Debug
    
    // Handle different response codes
    if (response.statusCode == 204) {
      // No content - successful deletion
      return;
    } else if (response.statusCode >= 200 && response.statusCode < 300) {
      // Successful deletion with content
      return;
    } else if (response.statusCode == 500) {
      // Check if it's a response validation error (deletion actually worked)
      if (response.body.contains('ResponseValidationError') || 
          response.body.contains('model_attributes_type')) {
        print('Deletion successful despite validation error'); // Debug
        return; // Treat as successful deletion
      } else {
        throw Exception('Error del servidor (500): ${response.body}');
      }
    } else if (response.statusCode == 307) {
      // Try with trailing slash
      url = '$baseUrl/$cleanEndpoint/$id/';
      print('Retrying with trailing slash: $url'); // Debug
      
      final retryResponse = await http.delete(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      
      print('Retry response status: ${retryResponse.statusCode}'); // Debug
      
      if (retryResponse.statusCode == 204 || 
          (retryResponse.statusCode >= 200 && retryResponse.statusCode < 300)) {
        return;
      } else if (retryResponse.statusCode == 500 && 
                 (retryResponse.body.contains('ResponseValidationError') || 
                  retryResponse.body.contains('model_attributes_type'))) {
        print('Deletion successful despite validation error on retry'); // Debug
        return; // Treat as successful deletion
      } else {
        throw Exception('Error del servidor: ${retryResponse.statusCode} - ${retryResponse.body}');
      }
    } else {
      throw Exception('Error del servidor: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    print('Error in ApiService.deleteData: $e'); // Debug
    throw Exception('Error al eliminar: $e');
  }
}
  // Método existente para guardar datos (POST/PUT)
  // Método para guardar datos (POST/PUT)
static Future<Map<String, dynamic>> save(String endpoint, int? id, Map<String, dynamic> data) async {
  try {
    String cleanEndpoint = endpoint.replaceAll('/', '');
    var url = id == null 
        ? '$baseUrl/$cleanEndpoint/'
        : '$baseUrl/$cleanEndpoint/$id';

    print('Saving to URL: $url'); // Debug
    print('Data: $data'); // Debug

    var uri = Uri.parse(url);
    
    http.Response response;
    do {
      response = id == null
          ? await http.post(uri, headers: {'Content-Type': 'application/json'}, body: json.encode(data))
          : await http.put(uri, headers: {'Content-Type': 'application/json'}, body: json.encode(data));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 307 || response.statusCode == 308) {
        // Extraer nueva ubicación de la cabecera Location
        final location = response.headers['location'];
        if (location != null) {
          // Construir nueva URI absoluta si es necesario
          uri = uri.resolve(location);
          print('Redirigiendo a: $uri');
        } else {
          throw Exception('Redirección sin header Location');
        }
      }

    } while (response.statusCode == 307 || response.statusCode == 308);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('Error del servidor: ${response.statusCode} - ${response.body}');
    }

  } on TimeoutException {
    throw Exception('Tiempo de espera agotado al guardar datos.');
  } on SocketException catch (e) {
    throw Exception('Error de conexión: ${e.message}');
  } catch (e) {
    print('Error en ApiService.save: $e');
    throw Exception('Error al guardar: $e');
  }
}

  static Future<Map<String, dynamic>> postData(String endpoint, Map<String, dynamic> data) async {
    return await save(endpoint, null, data);
  }

  static Future<Map<String, dynamic>> putData(String endpoint, int id, Map<String, dynamic> data) async {
    return await save(endpoint, id, data);
  }

  static Future<void> patch(String endpoint, Map<String, dynamic> data) async {
  final url = '$baseUrl/$endpoint';
  final response = await http.patch(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(data),
  );
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw Exception('Error al actualizar: ${response.statusCode} - ${response.body}');
  }
}
}