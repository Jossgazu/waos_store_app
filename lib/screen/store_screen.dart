import 'package:flutter/material.dart';
import 'package:waos_store_app/services/api_service.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  bool _isLoadingInventario = false;
  List<dynamic> _inventario = [];
  bool _isLoadingProductoVariantes = false;
  List<dynamic> _productoVariantes = [];
  bool _isLoadingProveedores = false;
  List<dynamic> _proveedores = [];
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadInventario(),
      _loadProductoVariantes(),
      _loadProveedores(),
    ]);
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
        SnackBar(
          content: Text('Error al cargar inventario: $e'),
          backgroundColor: Colors.red[700],
        ),
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
        SnackBar(
          content: Text('Error al cargar variantes: $e'),
          backgroundColor: Colors.red[700],
        ),
      );
    }
  }

  Future<void> _loadProveedores() async {
    setState(() => _isLoadingProveedores = true);
    try {
      final data = await ApiService.getData('proveedor');
      setState(() {
        _proveedores = data;
        _isLoadingProveedores = false;
      });
    } catch (e) {
      setState(() => _isLoadingProveedores = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar proveedores: $e'),
          backgroundColor: Colors.red[700],
        ),
      );
    }
  }

  void _recordMovement() {
    final _formKey = GlobalKey<FormState>();
    final Map<String, dynamic> _formData = {
      'tipo_movimiento': 'ENTRADA',
      'cantidad': 0,
      'precio_unitario': 0.0,
      'motivo': '',
      'numero_documento': '',
      'fk_producto_variante': _productoVariantes.isNotEmpty
          ? _productoVariantes.first['id_producto_variante']
          : null,
      'fk_usuario': 1, // Assuming user ID 1 for now
      'fk_proveedor': _proveedores.isNotEmpty
          ? _proveedores.first['id_proveedor']
          : null,
    };

    void _submit() async {
      if (!_formKey.currentState!.validate()) return;
      _formKey.currentState!.save();

      setState(() => _isProcessing = true);

      try {
        await ApiService.save('inventario', null, _formData);
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Movimiento registrado exitosamente'),
            backgroundColor: Colors.green[700],
          ),
        );
        _loadInventario();
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al registrar movimiento: $e'),
            backgroundColor: Colors.red[700],
          ),
        );
      } finally {
        if (mounted) setState(() => _isProcessing = false);
      }
    }

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Registrar Movimiento de Inventario'),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: _formData['tipo_movimiento'],
                      decoration: const InputDecoration(
                        labelText: 'Tipo de Movimiento',
                        border: OutlineInputBorder(),
                      ),
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
                      onChanged: (value) {
                        setState(() {
                          _formData['tipo_movimiento'] = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Seleccione un tipo' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Cantidad',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: '0',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese una cantidad';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Ingrese un número válido';
                        }
                        return null;
                      },
                      onSaved: (value) =>
                          _formData['cantidad'] = int.parse(value!),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Precio Unitario',
                        border: OutlineInputBorder(),
                        prefixText: 'S/ ',
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      initialValue: '0.00',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese un precio';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Ingrese un número válido';
                        }
                        return null;
                      },
                      onSaved: (value) =>
                          _formData['precio_unitario'] = double.parse(value!),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Motivo',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Ingrese un motivo' : null,
                      onSaved: (value) => _formData['motivo'] = value,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Número de Documento',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) => _formData['numero_documento'] = value,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField(
                      value: _formData['fk_producto_variante'],
                      decoration: const InputDecoration(
                        labelText: 'Variante de Producto',
                        border: OutlineInputBorder(),
                      ),
                      items: _productoVariantes.map<DropdownMenuItem>((variante) {
                        return DropdownMenuItem(
                          value: variante['id_producto_variante'],
                          child: Text(variante['nombre'] ?? 'Sin nombre'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _formData['fk_producto_variante'] = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Seleccione un producto' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField(
                      value: _formData['fk_proveedor'],
                      decoration: const InputDecoration(
                        labelText: 'Proveedor (opcional)',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('Ninguno'),
                        ),
                        ..._proveedores.map<DropdownMenuItem>((proveedor) {
                          return DropdownMenuItem(
                            value: proveedor['id_proveedor'],
                            child: Text(proveedor['nombre'] ?? 'Proveedor'),
                          );
                        }).toList(),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _formData['fk_proveedor'] = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: _isProcessing ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
                child: _isProcessing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : const Text('Registrar'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInventoryList() {
    if (_isLoadingInventario ||
        _isLoadingProductoVariantes ||
        _isLoadingProveedores) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
        ),
      );
    }

    if (_inventario.isEmpty) {
      return Center(
        child: Text(
          'No hay movimientos en el inventario',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _inventario.length,
      itemBuilder: (context, index) {
        final item = _inventario[index];
        final productoVariante = _productoVariantes.firstWhere(
          (pv) => pv['id_producto_variante'] == item['fk_producto_variante'],
          orElse: () => {'nombre': 'Producto desconocido'},
        );
        final tipoMovimiento = item['tipo_movimiento'];
        final cantidad = item['cantidad'] ?? 0;
        Color movimientoColor = Colors.grey;

        if (tipoMovimiento == 'ENTRADA') {
          movimientoColor = Colors.green;
        } else if (tipoMovimiento == 'SALIDA') {
          movimientoColor = Colors.red;
        } else if (tipoMovimiento == 'AJUSTE') {
          movimientoColor = Colors.orange;
        }

        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(
              productoVariante['nombre'],
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${tipoMovimiento.toString().toUpperCase()}: $cantidad',
                  style: TextStyle(
                    color: movimientoColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (item['motivo'] != null)
                  Text('Motivo: ${item['motivo']}'),
                if (item['numero_documento'] != null)
                  Text('Documento: ${item['numero_documento']}'),
                if (item['fecha'] != null)
                  Text(
                    'Fecha: ${DateTime.parse(item['fecha']).toLocal()}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (item['precio_unitario'] != null)
                  Text(
                    'S/ ${item['precio_unitario'].toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                if (item['stock_actual'] != null)
                  Text(
                    'Stock: ${item['stock_actual']}',
                    style: TextStyle(
                      color: (item['stock_actual'] ?? 0) > 10
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gestión de Inventario',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueAccent.withOpacity(0.1), Colors.grey[50]!],
          ),
        ),
        child: Column(
          children: [
            Expanded(child: _buildInventoryList()),
            Card(
              margin: const EdgeInsets.all(16),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Registrar Movimiento',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    ElevatedButton.icon(
                      onPressed: _recordMovement,
                      icon: const Icon(Icons.inventory_2),
                      label: const Text('Nuevo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}