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
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([_loadInventario(), _loadProductoVariantes()]);
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

  void _updateStock(int? productoVarianteId) {
    if (productoVarianteId == null) return;

    final _stockController = TextEditingController();
    bool _isSubmitting = false;

    void _submit() async {
      if (_stockController.text.isEmpty) return;

      setState(() => _isSubmitting = true);

      try {
        final data = {'stock_actual': int.parse(_stockController.text)};

        await ApiService.patch(
          'inventario/$productoVarianteId/ajustar-stock',
          data,
        );
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Stock actualizado exitosamente'),
            backgroundColor: Colors.green[700],
          ),
        );
        _loadInventario();
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar stock: $e'),
            backgroundColor: Colors.red[700],
          ),
        );
      } finally {
        if (mounted) setState(() => _isSubmitting = false);
      }
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Actualizar Stock'),
        content: TextField(
          controller: _stockController,
          decoration: const InputDecoration(
            labelText: 'Nuevo Stock',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: _isSubmitting ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : const Text('Actualizar'),
          ),
        ],
      ),
    );
  }

  void _recordMovement() {
    final _formKey = GlobalKey<FormState>();
    final Map<String, dynamic> _formData = {
      'tipo_movimiento': 'ENTRADA',
      'fk_producto_variante': _productoVariantes.isNotEmpty
          ? _productoVariantes.first['id_producto_variante']
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
        builder: (context, setState) => AlertDialog(
          title: const Text('Registrar Movimiento'),
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
                      DropdownMenuItem(value: 'SALIDA', child: Text('Salida')),
                      DropdownMenuItem(value: 'AJUSTE', child: Text('Ajuste')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _formData['tipo_movimiento'] = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Cantidad',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese una cantidad';
                      }
                      return null;
                    },
                    onSaved: (value) =>
                        _formData['cantidad'] = int.parse(value!),
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
        ),
      ),
    );
  }

  Widget _buildProductList() {
    if (_isLoadingInventario || _isLoadingProductoVariantes) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
        ),
      );
    }

    if (_inventario.isEmpty) {
      return Center(
        child: Text(
          'No hay productos en el inventario',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _inventario.length,
      itemBuilder: (context, index) {
        final item = _inventario[index];
        final stock = item['stock_actual'] ?? 0;

        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(
              item['nombre'] ?? 'Producto sin nombre',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              'Stock: $stock',
              style: TextStyle(
                color: stock > 10 ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit, color: Colors.blueAccent),
              onPressed: () => _updateStock(item['id_producto_variante']),
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
            Expanded(child: _buildProductList()),
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
