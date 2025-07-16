import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

class ComprobantesMesScreen extends StatefulWidget {
  const ComprobantesMesScreen({Key? key}) : super(key: key);

  @override
  State<ComprobantesMesScreen> createState() => _ComprobantesMesScreenState();
}

class _ComprobantesMesScreenState extends State<ComprobantesMesScreen> {
  bool _isDownloading = false;

                           Future<void> _downloadComprobantes(String fecha) async {
                setState(() => _isDownloading = true);
                try {
                  // Extraer solo el año y mes de la fecha
                  final dateTime = DateTime.parse(fecha);
                  final periodo = '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}'; // Formato YYYY-MM
              
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

  List<String> _getLast12Months() {
    final now = DateTime.now();
    return List.generate(12, (index) {
      final monthDate = DateTime(now.year, now.month - index, 1);
      return '${monthDate.year}-${monthDate.month.toString().padLeft(2, '0')}-01';
    });
  }

  @override
  Widget build(BuildContext context) {
    final months = _getLast12Months();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Comprobantes Este Mes',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: months.length,
          itemBuilder: (context, index) {
            final month = months[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(
                  'Comprobantes de ${DateTime.parse(month).month}/${DateTime.parse(month).year}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  'Descargar comprobantes de este mes',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                trailing: _isDownloading
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.download, color: Colors.blueAccent),
                onTap: _isDownloading
                    ? null
                    : () {
                        _downloadComprobantes(month);
                      },
              ),
            );
          },
        ),
      ),
    );
  }
}
