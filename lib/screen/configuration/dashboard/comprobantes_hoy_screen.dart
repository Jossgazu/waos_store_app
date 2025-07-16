import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart'; // Importa esta librería para abrir el archivo
import 'package:waos_store_app/services/api_service.dart'; // Importa el servicio para obtener datos

class ComprobantesHoyScreen extends StatefulWidget {
  const ComprobantesHoyScreen({Key? key}) : super(key: key);

  @override
  State<ComprobantesHoyScreen> createState() => _ComprobantesHoyScreenState();
}

class _ComprobantesHoyScreenState extends State<ComprobantesHoyScreen> {
  bool _isLoading = false;
  List<dynamic> _comprobantes = [];

  @override
  void initState() {
    super.initState();
    _loadComprobantesHoy();
  }

  Future<void> _loadComprobantesHoy() async {
    setState(() => _isLoading = true);
    try {
      final data = await ApiService.getData('comprobantes/hoy');
      setState(() {
        _comprobantes = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar comprobantes: $e'),
          backgroundColor: Colors.red[700],
        ),
      );
    }
  }

  Future<void> _downloadComprobante(int comprobanteId) async {
    try {
      final url = 'http://localhost:8000/comprobantes/descargar/$comprobanteId';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/comprobante_$comprobanteId.pdf';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Comprobante descargado: $filePath'),
            backgroundColor: Colors.green[700],
          ),
        );

        // Abre el archivo después de descargarlo
        OpenFile.open(filePath);
      } else {
        throw Exception('Error al descargar comprobante: ${response.statusCode}');
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
          'Comprobantes Hoy',
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
          : _comprobantes.isEmpty
              ? const Center(
                  child: Text(
                    'No hay comprobantes generados hoy.',
                    style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _comprobantes.length,
                  itemBuilder: (context, index) {
                    final comprobante = _comprobantes[index];
                    final cabecera = comprobante['cabecera'];
                    final detalle = comprobante['detalle'];

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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Tipo: ${cabecera['tipo_comprobante']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.download, color: Colors.blueAccent),
                                  onPressed: () => _downloadComprobante(cabecera['id_comprobante_cabecera']),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Serie: ${cabecera['serie_correlativo']}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              'Fecha: ${DateTime.parse(cabecera['fecha']).toLocal()}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              'Método de Pago: ${cabecera['metodo_pago']}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              'Total: S/${cabecera['pago_total'].toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.green,
                              ),
                            ),
                            const Divider(),
                            const Text(
                              'Detalle:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            ...detalle.map<Widget>((item) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                  '- Producto Variante ID: ${item['fk_producto_variante']}, Cantidad: ${item['cantidad']}, Precio: S/${item['precio_producto'].toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 14),
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