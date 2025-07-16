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
  Map<String, List<Map<String, dynamic>>> _dropdownOptions = {};

  @override
void initState() {
  super.initState();
  _fieldConfigs = FormConfig.getConfig(widget.endpoint) ?? [];
  for (var config in _fieldConfigs) {
    if (config.type == 'text' ||
        config.type == 'textarea' ||
        config.type == 'number' ||
        config.type == 'phone' ||
        config.type == 'password' ||      // <-- agrega esto
        config.type == 'email') {         // <-- y esto
      _controllers[config.field] = TextEditingController(
        text: widget.initialData?[config.field]?.toString() ?? '',
      );
    }
    _formData[config.field] =
        widget.initialData?[config.field] ?? config.defaultValue;
  }
  _loadDropdownOptions();
}

  Future<void> _loadDropdownOptions() async {
  for (var config in _fieldConfigs.where((c) => c.type == 'dropdown')) {
    String? entity = _getEntityFromField(config.field);
    if (entity != null) {
      final data = await ApiService.getData(entity);
      setState(() {
        _dropdownOptions[config.field] = data;
      });
    }
  }
}

String? _getEntityFromField(String field) {
  if (field.startsWith('fk_')) {
    return field.substring(3).replaceAll('_', '-').toLowerCase();
  }
  if (field.startsWith('fk')) {
    return field.substring(2).replaceAll('_', '-').toLowerCase();
  }
  return null;
}

  String _getIdFieldForEntity(String entity) {
    // Puedes mejorar este mapeo según tus convenciones
    switch (entity) {
      case 'categoria':
        return 'id_categoria';
      case 'producto':
        return 'id_producto';
      case 'empresa':
        return 'id_empresa';
      case 'sucursal':
        return 'id_sucursal';
      case 'usuario':
        return 'id_usuario';
      // case 'rol':
      //   return 'id_rol';
      case 'proveedor':
        return 'id_proveedor';
      case 'metodo-pago':
        return 'id_metodo_pago';
      case 'comprobante-cabecera':
        return 'id_comprobante_cabecera';
      case 'comprobante-detalle':
        return 'id_comprobante_detalle';
      case 'pago':
        return 'id_pago';
      case 'inventario':
        return 'id_inventario';
      case 'producto-variante':
        return 'id_producto_variante';
      default:
        return 'id';
    }
  }

  Widget _buildFormFields() {
    return Column(
      children: _fieldConfigs.map((config) {
        if (config.type == 'dropdown') {
          final entity = _getEntityFromField(config.field);
          final options = config.options ?? _dropdownOptions[config.field] ?? [];
  final idField = config.options != null ? 'value' : (entity != null ? _getIdFieldForEntity(entity) : 'id');
  final labelField = config.options != null ? 'label' : 'nombre';

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: DropdownButtonFormField<dynamic>(
      value: _formData[config.field],
      decoration: InputDecoration(
        labelText: config.label,
        border: const OutlineInputBorder(),
      ),
      items: options.map<DropdownMenuItem<dynamic>>((item) {
        return DropdownMenuItem(
          value: item[idField],
          child: Text(item[labelField] ?? item['descripcion'] ?? item[idField].toString()),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _formData[config.field] = value;
        });
      },
      validator: (value) {
        if (config.required && (value == null || value.toString().isEmpty)) {
          return '${config.label} es obligatorio';
        }
        return null;
      },
    ),
  );
}
        // ...otros tipos de campos...
        // ...existing code...
if (config.type == 'text' ||
    config.type == 'textarea' ||
    config.type == 'number' ||
    config.type == 'phone' ||
    config.type == 'password' || // <--- agrega esto
    config.type == 'email') {    // <--- y esto
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
      obscureText: config.type == 'password', // <--- para ocultar contraseña
      keyboardType: config.type == 'number'
          ? TextInputType.number
          : config.type == 'phone'
              ? TextInputType.phone
              : config.type == 'email'
                  ? TextInputType.emailAddress
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
              ? 0
              : double.tryParse(value);
        } else {
          _formData[config.field] = value;
        }
      },
    ),
  );
}
        if (config.type == 'switch') {
          return SwitchListTile(
            title: Text(config.label),
            value: _formData[config.field] ?? config.defaultValue ?? false,
            onChanged: (value) {
              setState(() {
                _formData[config.field] = value;
              });
            },
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
      await ApiService.save(
        widget.endpoint,
        widget.initialData?['id'],
        _formData,
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
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