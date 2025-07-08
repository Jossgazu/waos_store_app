import 'package:flutter/material.dart';
import 'package:waos_store_app/models/form_config.dart';
import 'package:waos_store_app/models/form_field_config.dart';
import 'package:waos_store_app/services/api_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:flutter/foundation.dart'; // Para detectar la plataforma
import 'package:image_picker/image_picker.dart'; // Para móviles
import 'package:file_selector/file_selector.dart'; // Para Linux


class FormScreen extends StatefulWidget {
  final String title;

  final String endpoint;
  
  final Map<String, dynamic>? initialData;

  const FormScreen({
    Key? key,
    required this.title,
    required this.endpoint,
    this.initialData,
  }) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  Map<String, TextEditingController> _controllers = {};
  Map<String, dynamic> _formData = {};
  bool _isLoading = false;
  List<FormFieldConfig> _fieldConfigs = [];
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    // Configuración específica para Producto Variante
    _fieldConfigs = [
      FormFieldConfig(
        field: 'nombre_variante',
        label: 'Nombre de la Variante',
        type: 'text',
        required: true,
      ),
      FormFieldConfig(
        field: 'precio_adicional',
        label: 'Precio Adicional',
        type: 'number',
        hint: 'Ingrese el precio adicional de la variante',
        required: true,
      ),
      FormFieldConfig(
        field: 'imagen_variante',
        label: 'Imagen de la Variante',
        type: 'image',
        required: false,
      ),
      FormFieldConfig(
        field: 'activo',
        label: 'Activo',
        type: 'switch',
        defaultValue: true,
      ),
    ];

    // Inicializar controladores y datos
    for (var config in _fieldConfigs) {
      if (config.type == 'text' || config.type == 'number') {
        _controllers[config.field] = TextEditingController(
          text: widget.initialData?[config.field]?.toString() ?? '',
        );
      }
      _formData[config.field] =
          widget.initialData?[config.field] ?? config.defaultValue;
    }
  }

  Widget _buildFormFields() {
    return Column(
      children: _fieldConfigs.map((config) {
        if (config.type == 'image') {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    config.label,
                    style: TextStyle(color: Colors.blueGrey[700]),
                  ),
                  const SizedBox(height: 8),
                
ElevatedButton(
  onPressed: () async {
    try {
      if (kIsWeb || Platform.isLinux) {
        final XTypeGroup typeGroup = XTypeGroup(
          label: 'images',
          extensions: ['jpg', 'jpeg', 'png'],
        );
        final XFile? pickedFile = await openFile(acceptedTypeGroups: [typeGroup]);
        if (pickedFile != null) {
          setState(() {
            _imageFile = pickedFile;
          });
        }
      } else if (Platform.isAndroid || Platform.isIOS) {
        final pickedFile = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
        );
        if (pickedFile != null) {
          setState(() {
            _imageFile = pickedFile;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('La selección de imágenes no está soportada en esta plataforma.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blueAccent,
    foregroundColor: Colors.white,
  ),
  child: const Text('Seleccionar Imagen'),
),
                  const SizedBox(height: 8),
                  if (_imageFile != null)
                    Image.file(
                      File(_imageFile!.path),
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  else if (_formData['imagen_variante'] != null && 
                          _formData['imagen_variante'] is String)
                    Image.network(
                      _formData['imagen_variante'],
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 100);
                      },
                    ),
                ],
              ),
            ),
          );
        }

        if (config.type == 'text' || config.type == 'number') {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: TextFormField(
                controller: _controllers[config.field],
                decoration: InputDecoration(
                  labelText: config.label,
                  hintText: config.hint,
                  border: InputBorder.none,
                  labelStyle: TextStyle(color: Colors.blueGrey[700]),
                ),
                style: const TextStyle(color: Colors.blueGrey),
                keyboardType: config.type == 'number'
                    ? TextInputType.numberWithOptions(decimal: true)
                    : TextInputType.text,
                validator: (value) {
                  if (config.required && (value == null || value.isEmpty)) {
                    return '${config.label} es obligatorio';
                  }
                  if (config.type == 'number' && value != null && value.isNotEmpty) {
                    if (double.tryParse(value) == null) {
                      return 'Ingrese un número válido';
                    }
                  }
                  return null;
                },
                onSaved: (value) {
                  if (config.type == 'number') {
                    _formData[config.field] = (value == null || value.isEmpty)
                        ? 0.0
                        : double.tryParse(value);
                  } else {
                    _formData[config.field] = value;
                  }
                },
              ),
            ),
          );
        }

        if (config.type == 'switch') {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SwitchListTile(
              title: Text(
                config.label,
                style: TextStyle(color: Colors.blueGrey[700]),
              ),
              value: _formData[config.field] ?? config.defaultValue ?? false,
              onChanged: (value) {
                setState(() {
                  _formData[config.field] = value;
                });
              },
            ),
          );
        }

        return const SizedBox.shrink();
      }).toList(),
    );
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      final formData = FormData();

      // Agregar campos normales
      formData.fields.addAll(
        _formData.entries
            .where((entry) => entry.key != 'imagen_variante')
            .map((entry) => MapEntry(entry.key, entry.value.toString())),
      );

      // Agregar imagen si existe
      if (_imageFile != null) {
        formData.files.add(MapEntry(
          'imagen_variante',
          await MultipartFile.fromFile(
            _imageFile!.path,
            filename: 'variante_${DateTime.now().millisecondsSinceEpoch}.jpg',
          ),
        ));
      }

      await ApiService.save(
        widget.endpoint,
        widget.initialData?['id_producto_variante'],
        formData as Map<String, dynamic>,
      );
      
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blueAccent.withOpacity(0.1),
              Colors.grey[50]!,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildFormFields(),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _save,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Guardar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }
}