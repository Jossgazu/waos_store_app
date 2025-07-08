import 'package:flutter/material.dart';
import 'package:waos_store_app/services/api_service.dart';
import 'package:waos_store_app/models/form_config.dart';
import 'package:waos_store_app/models/form_field_config.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  bool _isLoadingInventario = false;
  List<dynamic> _inventario = [];
  bool _isLoadingProductos = false;
  List<dynamic> _productos = [];
  bool _isLoadingProductoVariantes = false;
  List<dynamic> _productoVariantes = [];
  bool _isAddingProducto = false;
  bool _isUpdatingStock = false;
  bool _isRecordingMovement = false;

  @override
  void initState() {
    super.initState();
    _loadInventario();
    _loadProductos();
    _loadProductoVariantes();
  }

  Future<void> _loadInventario() async {
    setState(() => _isLoadingInventario = true);
    try {
      final data = await ApiService.getData('inventario');
      setState(() {
        _inventario = data;
        _isLoadingInventario = false;
      });
    } catch (e) {
      setState(() => _isLoadingInventario = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar inventario: $e')),
      );
    }
  }

  Future<void> _loadProductos() async {
    setState(() => _isLoadingProductos = true);
    try {
      final data = await ApiService.getData('producto');
      setState(() {
        _productos = data;
        _isLoadingProductos = false;
      });
    } catch (e) {
      setState(() => _isLoadingProductos = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar productos: $e')),
      );
    }
  }

  Future<void> _loadProductoVariantes() async {
    setState(() => _isLoadingProductoVariantes = true);
    try {
      final data = await ApiService.getData('producto-variante');
      setState(() {
        _productoVariantes = data;
        _isLoadingProductoVariantes = false;
      });
    } catch (e) {
      setState(() => _isLoadingProductoVariantes = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar variantes: $e')),
      );
    }
  }
  

  void _updateStock(int? productoVarianteId) {
    if (productoVarianteId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se puede editar: Variante no disponible')),
      );
      return;
    }
    final _formKey = GlobalKey<FormState>();
    Map<String, TextEditingController> _controllers = {};
    Map<String, dynamic> _formData = {};
    bool _isSubmitting = false;

    void _submit() async {
      if (!_formKey.currentState!.validate()) return;

      _formKey.currentState!.save();
      setState(() => _isSubmitting = true);

      try {
        final data = {
          'stock_actual': _formData['stock_actual'],
        };

        await ApiService.patch('inventario/$productoVarianteId/ajustar-stock', data);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Stock actualizado exitosamente')),
        );
        _loadInventario();
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar stock: $e')),
        );
      } finally {
        setState(() => _isSubmitting = false);
      }
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Actualizar Stock'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _controllers['stock_actual'] ??= TextEditingController(),
                  decoration: const InputDecoration(labelText: 'Nuevo Stock'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nuevo Stock es obligatorio';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Ingrese un número válido';
                    }
                    return null;
                  },
                  onSaved: (value) => _formData['stock_actual'] = int.parse(value!),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: _isSubmitting ? null : _submit,
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(),
                  )
                : const Text('Actualizar Stock'),
          ),
        ],
      ),
    );
  }

  void _recordMovement() {
    final _formKey = GlobalKey<FormState>();
    Map<String, TextEditingController> _controllers = {};
    Map<String, dynamic> _formData = {};
    bool _isSubmitting = false;

    void _submit() async {
      if (!_formKey.currentState!.validate()) return;

      _formKey.currentState!.save();
      setState(() => _isSubmitting = true);

      try {
        final data = {
          'tipo_movimiento': (_formData['tipo_movimiento'] as String).toUpperCase(),
          'cantidad': _formData['cantidad'],
          'fk_producto_variante': _formData['fk_producto_variante'],
          'fk_usuario': 1,
          'motivo': _formData['motivo'] ?? '',
          'numero_documento': _formData['numero_documento'] ?? '',
          'fk_proveedor': _formData['fk_proveedor'] ?? null,
        };

        await ApiService.save('inventario', null, data);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Movimiento registrado exitosamente')),
        );
        _loadInventario();
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar movimiento: $e')),
        );
      } finally {
        setState(() => _isSubmitting = false);
      }
    }

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Registrar Movimiento'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: _formData['tipo_movimiento'],
                    decoration: const InputDecoration(labelText: 'Tipo de Movimiento'),
                    items: const [
                      DropdownMenuItem(
                        value: 'ENTRADA',
                        child: Text('Entrada'),
                      ),
                      DropdownMenuItem(
                        value: 'SALIDA',
                        child: Text('Salida'),
                      ),
                      DropdownMenuItem(
                        value: 'AJUSTE',
                        child: Text('Ajuste'),
                      ),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tipo de Movimiento es obligatorio';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _formData['tipo_movimiento'] = value;
                      });
                    },
                  ),
                  TextFormField(
                    controller: _controllers['cantidad'] ??= TextEditingController(),
                    decoration: const InputDecoration(labelText: 'Cantidad'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Cantidad es obligatorio';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Ingrese un número válido';
                      }
                      return null;
                    },
                    onSaved: (value) => _formData['cantidad'] = int.parse(value!),
                  ),
                  DropdownButtonFormField<int>(
                    value: _formData['fk_producto_variante'] is int
                        ? _formData['fk_producto_variante']
                        : (_productoVariantes.isNotEmpty ? _productoVariantes.first['id_producto_variante'] : null),
                    decoration: const InputDecoration(labelText: 'Variante de Producto'),
                    items: _productoVariantes.map<DropdownMenuItem<int>>((variante) {
                      return DropdownMenuItem<int>(
                        value: variante['id_producto_variante'],
                        child: Text(variante['nombre']),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Variante de Producto es obligatorio';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _formData['fk_producto_variante'] = value;
                      });
                    },
                  ),
                  TextFormField(
                    controller: _controllers['motivo'] ??= TextEditingController(),
                    decoration: const InputDecoration(labelText: 'Motivo'),
                    onSaved: (value) => _formData['motivo'] = value,
                  ),
                  TextFormField(
                    controller: _controllers['numero_documento'] ??= TextEditingController(),
                    decoration: const InputDecoration(labelText: 'Número de Documento'),
                    onSaved: (value) => _formData['numero_documento'] = value,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    )
                  : const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList() {
    if (_isLoadingInventario) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_inventario.isEmpty) {
      return const Center(child: Text('No hay productos en el inventario'));
    }
    return ListView.builder(
      itemCount: _inventario.length,
      itemBuilder: (context, index) {
        final producto = _inventario[index];
        return ListTile(
          title: Text(producto['nombre'] ?? 'Nombre no disponible'),
          subtitle: Text('Stock: ${producto['stock_actual']}'),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: producto['id_producto_variante'] != null
                ? () => _updateStock(producto['id_producto_variante'])
                : null,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Inventario')),
      body: Column(
        children: [
          Expanded(
            child: _buildProductList(),
          ),
          Card(
            margin: const EdgeInsets.all(16),
            child: Column(
              children: [
                ListTile(
                  title: const Text('Registrar Movimiento'),
                  trailing: IconButton(
                    icon: const Icon(Icons.move_to_inbox),
                    onPressed: _recordMovement,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}