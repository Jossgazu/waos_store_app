import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'dart:convert';

class ComprobantesPorMesesScreen extends StatefulWidget {
  const ComprobantesPorMesesScreen({Key? key}) : super(key: key);

  @override
  State<ComprobantesPorMesesScreen> createState() =>
      _ComprobantesPorMesesScreenState();
}

class _ComprobantesPorMesesScreenState
    extends State<ComprobantesPorMesesScreen> {
  bool _isLoading = false;
  List<Map<String, dynamic>> _comprobantesPorMes = [];

  @override
  void initState() {
    super.initState();
    _loadComprobantesPorMes();
  }

  List<Map<String, int>> _getLast12Months() {
    final now = DateTime.now();
    return List.generate(12, (index) {
      final monthDate = DateTime(now.year, now.month - index, 1);
      return {'anio': monthDate.year, 'mes': monthDate.month};
    });
  }

  Future<void> _loadComprobantesPorMes() async {
    setState(() => _isLoading = true);
    try {
      final months = _getLast12Months();
      List<Map<String, dynamic>> comprobantes = [];

      for (var month in months) {
        final response = await http.get(
          Uri.parse(
              'http://localhost:8000/comprobantes/por-mes?año=${month['anio']}&mes=${month['mes']}'),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data.isNotEmpty) {
            comprobantes.add({'anio': month['anio'], 'mes': month['mes'], 'comprobantes': data});
          }
        } else {
          throw Exception(
              'Error al obtener comprobantes para el mes ${month['mes']} del año ${month['anio']}');
        }
      }

      setState(() {
        _comprobantesPorMes = comprobantes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar comprobantes por mes: $e'),
          backgroundColor: Colors.red[700],
        ),
      );
    }
  }

  Future<void> _downloadComprobantesPorAnio(int anio) async {
    try {
      final url = 'http://localhost:8000/comprobantes/descargar/por-anio/$anio';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final filePath = '${tempDir.path}/comprobantes_$anio.zip';
        final file = await File(filePath).writeAsBytes(response.bodyBytes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Comprobantes descargados exitosamente'),
            backgroundColor: Colors.green[700],
          ),
        );

        OpenFile.open(file.path);
      } else {
        throw Exception('Error al descargar comprobantes por año');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al descargar comprobantes: $e'),
          backgroundColor: Colors.red[700],
        ),
      );
    }
  }
Future<void> _downloadComprobantesPorMes(int anio, int mes) async {
  try {
    // Formatear el mes con ceros a la izquierda para asegurar que siempre tenga 2 dígitos
    final mesFormateado = mes.toString().padLeft(2, '0');
    final periodo = '$anio-$mesFormateado'; // Formato YYYY-MM
    
    // Construir la URL con el formato correcto
    final url = 'http://localhost:8000/comprobantes/descargar/por-mes-formato/?periodo=$periodo';
    
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/comprobantes_$periodo.zip';
      final file = await File(filePath).writeAsBytes(response.bodyBytes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Comprobantes descargados exitosamente'),
          backgroundColor: Colors.green[700],
        ),
      );

      OpenFile.open(file.path);
    } else {
      throw Exception('Error al descargar comprobantes por mes: ${response.statusCode}');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error al descargar comprobantes: $e'),
        backgroundColor: Colors.red[700],
      ),
    );
  }
}
  Future<void> _downloadComprobanteIndividual(int comprobanteId) async {
    try {
      final url =
          'http://localhost:8000/comprobantes/descargar/$comprobanteId';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final filePath = '${tempDir.path}/comprobante_$comprobanteId.pdf';
        final file = await File(filePath).writeAsBytes(response.bodyBytes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Comprobante descargado exitosamente'),
            backgroundColor: Colors.green[700],
          ),
        );

        OpenFile.open(file.path);
      } else {
        throw Exception('Error al descargar comprobante');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al descargar comprobante: $e'),
          backgroundColor: Colors.red[700],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Comprobantes por Meses',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              ),
            )
          : _comprobantesPorMes.isEmpty
              ? const Center(
                  child: Text(
                    'No hay comprobantes disponibles.',
                    style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _comprobantesPorMes.length,
                  itemBuilder: (context, index) {
                    final comprobanteMes = _comprobantesPorMes[index];
                    final anio = comprobanteMes['anio'];
                    final mes = comprobanteMes['mes'];
                    final comprobantes = comprobanteMes['comprobantes'];

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mes: $mes/$anio',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () =>
                                  _downloadComprobantesPorMes(anio, mes),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Descargar todos los comprobantes'),
                            ),
                            const Divider(),
                            const Text(
                              'Comprobantes individuales:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                        ...comprobantes.map<Widget>((comprobante) {
                              final cabecera = comprobante['cabecera'];
                              return ListTile(
                                title: Text(
                                  'ID: ${cabecera['id_comprobante_cabecera']} - Serie: ${cabecera['serie_correlativo']}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.download),
                                  color: Colors.blueAccent,
                                  onPressed: () => _downloadComprobanteIndividual(
                                    cabecera['id_comprobante_cabecera'],
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}