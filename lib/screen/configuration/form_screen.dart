import 'package:flutter/material.dart';
import 'package:waos_store_app/models/form_config.dart';
import 'package:waos_store_app/models/form_field_config.dart';
import 'package:waos_store_app/services/api_service.dart'; // Asegúrate de que esta importación sea correcta

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

  @override
  void initState() {
    super.initState();
    print('FormScreen endpoint: ${widget.endpoint}'); // Debug

    // Obtener configuración y proporcionar una lista vacía si es null
    _fieldConfigs = FormConfig.getConfig(widget.endpoint) ?? [];

    print('Field configs found: ${_fieldConfigs.length}'); // Debug

    // Inicializar controllers y datos del formulario
    for (var config in _fieldConfigs) {
      // Inicializar controllers solo para tipos de entrada de texto
      if (config.type == 'text' ||
          config.type == 'textarea' ||
          config.type == 'number' ||
          config.type == 'phone') {
        _controllers[config.field] = TextEditingController(
          text: widget.initialData?[config.field]?.toString() ?? '',
        );
      }

      // Inicializar datos del formulario con valores por defecto o iniciales
      _formData[config.field] =
          widget.initialData?[config.field] ?? config.defaultValue;
    }
  }

  @override
  void dispose() {
    // Liberar recursos de los controllers
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildFormFields() {
    return Column(
      children: _fieldConfigs.map((config) {
        switch (config.type) {
          case 'text':
          case 'textarea':
          case 'number':
          case 'phone':
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: _controllers[config.field],
                decoration: InputDecoration(
                  labelText: config.label,
                  hintText: config.hint,
                  border: const OutlineInputBorder(),
                ),
                maxLines: config.type == 'textarea' ? 3 : 1,
                keyboardType: config.type == 'number'
                    ? TextInputType.number
                    : config.type == 'phone'
                    ? TextInputType.phone
                    : TextInputType.text,
                validator: (value) {
  if (config.required && (value == null || value.isEmpty)) {
    return '${config.label} es obligatorio';
  }
  return null;
},
                onSaved: (value) {
  if (config.type == 'number') {
    _formData[config.field] = (value == null || value.isEmpty)
        ? 0 // <-- aquí el valor por defecto
        : double.tryParse(value);
  } else {
    _formData[config.field] = value;
  }
},
              ),
            );

          case 'switch':
            return SwitchListTile(
              title: Text(config.label),
              value: _formData[config.field] ?? config.defaultValue ?? false,
              onChanged: (value) {
                setState(() {
                  _formData[config.field] = value;
                });
              },
            );

          default:
            return SizedBox.shrink();
        }
      }).toList(),
    );
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      // Guardar los datos utilizando ApiService
      await ApiService.save(
        widget.endpoint,
        widget.initialData?['id'],
        _formData,
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_fieldConfigs.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: const Center(
          child: Text('Configuración de formulario no encontrada'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
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
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(),
                      )
                    : const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
