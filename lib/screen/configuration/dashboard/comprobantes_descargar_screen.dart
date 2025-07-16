import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

class ComprobanteDescargarScreen extends StatefulWidget {
  const ComprobanteDescargarScreen({Key? key}) : super(key: key);

  @override
  State<ComprobanteDescargarScreen> createState() =>
      _ComprobanteDescargarScreenState();
}

class _ComprobanteDescargarScreenState
    extends State<ComprobanteDescargarScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fechaInicioController = TextEditingController();
  final TextEditingController _fechaFinController = TextEditingController();
  bool _isDownloading = false;

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = picked.toIso8601String().split('T')[0]; // Formato YYYY-MM-DD
    }
  }

  Future<void> _downloadComprobantes(String fechaInicio, String fechaFin) async {
    setState(() => _isDownloading = true);
    try {
      final url =
          'http://localhost:8000/comprobantes/descargar/por-rango-fechas/?fecha_inicio=$fechaInicio&fecha_fin=$fechaFin';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final filePath = '${tempDir.path}/comprobantes_$fechaInicio-$fechaFin.zip';
        final file = await File(filePath).writeAsBytes(response.bodyBytes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Comprobantes descargados exitosamente'),
            backgroundColor: Colors.green[700],
          ),
        );

        OpenFile.open(file.path);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al descargar comprobantes: ${response.statusCode}'),
            backgroundColor: Colors.red[700],
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red[700],
        ),
      );
    } finally {
      setState(() => _isDownloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Descargar Comprobantes',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Seleccione el rango de fechas:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _fechaInicioController,
                      decoration: const InputDecoration(
                        labelText: 'Fecha de Inicio (YYYY-MM-DD)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese la fecha de inicio';
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today, color: Colors.blueAccent),
                    onPressed: () => _selectDate(context, _fechaInicioController),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _fechaFinController,
                      decoration: const InputDecoration(
                        labelText: 'Fecha de Fin (YYYY-MM-DD)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese la fecha de fin';
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today, color: Colors.blueAccent),
                    onPressed: () => _selectDate(context, _fechaFinController),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isDownloading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          _downloadComprobantes(
                            _fechaInicioController.text,
                            _fechaFinController.text,
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: _isDownloading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(),
                      )
                    : const Text('Descargar Comprobantes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}