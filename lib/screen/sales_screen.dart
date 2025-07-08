import 'package:flutter/material.dart';
import 'package:waos_store_app/services/api_service.dart';
import 'package:waos_store_app/models/form_config.dart';
import 'package:waos_store_app/models/form_field_config.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  bool _isLoadingProductos = false;
  List<dynamic> _productos = [];
  List<Map<String, dynamic>> _carrito = [];
  double _total = 0.0;
  bool _isProcessingSale = false;

  @override
  void initState() {
    super.initState();
    _loadProductos();
  }

        Future<void> _loadProductos() async {
      setState(() => _isLoadingProductos = true);
      try {
        // 1. Obtén todas las variantes y todo el inventario
        final variantsData = await ApiService.getData('producto-variante');
        final inventarioData = await ApiService.getData('inventario');
    
        // 2. Relaciona cada variante con su stock
        List<dynamic> productosConStock = [];
                // ...existing code in _loadProductos...
        for (var variant in variantsData) {
          int variantId = variant['id_producto_variante'];
          // Filtra todos los movimientos de inventario para esta variante
          final movimientos = inventarioData
              .where((inv) => inv['fk_producto_variante'] == variantId)
              .toList();
          // Si hay movimientos, toma el de mayor id_inventario (más reciente)
          int currentStock = 0;
          if (movimientos.isNotEmpty) {
            movimientos.sort((a, b) => (b['id_inventario'] as int).compareTo(a['id_inventario'] as int));
            currentStock = movimientos.first['stock_actual'] ?? 0;
          }
          variant['stock_actual'] = currentStock;
          productosConStock.add(variant);
        }
        // ...resto del código...
    
        setState(() {
          _productos = productosConStock;
          _isLoadingProductos = false;
        });
      } catch (e) {
        setState(() => _isLoadingProductos = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar variantes: $e')),
        );
      }
    }
  void _addToCart(int index, int cantidad) {
    if (cantidad <= 0) return;

    final producto = _productos[index];
    int currentStock = producto['stock_actual'] ?? 0;

    // 3. Verificar stock disponible
    int existingIndex = _carrito.indexWhere(
      (item) => item['id_producto_variante'] == producto['id_producto_variante']
    );
    
    int currentCartQuantity = 0;
    if (existingIndex != -1) {
      currentCartQuantity = _carrito[existingIndex]['cantidad'];
    }
    
    int newQuantity = currentCartQuantity + cantidad;

    if (newQuantity > currentStock) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Stock insuficiente. Disponible: $currentStock')),
      );
      return;
    }

    setState(() {
      if (existingIndex != -1) {
        _carrito[existingIndex]['cantidad'] = newQuantity;
      } else {
        // 4. Almacenar IDs de producto y variante
        _carrito.add({
  'id_producto_variante': producto['id_producto_variante'],
  'id_producto': producto['fk_producto'],
  'nombre': producto['nombre'],
  'precio': (double.tryParse(producto['precio_base'].toString()) ?? 0.0) + (double.tryParse(producto['precio_adicional'].toString()) ?? 0.0),
  'cantidad': cantidad,
});
      }
      _calculateTotal();
    });
  }

  void _removeFromCart(int index) {
    setState(() {
      _carrito.removeAt(index);
      _calculateTotal();
    });
  }

  void _calculateTotal() {
    double total = 0.0;
    for (var item in _carrito) {
  final precio = item['precio'] ?? 0.0;
  final cantidad = item['cantidad'] ?? 0;
  total += precio * cantidad;
}
    setState(() {
      _total = total;
    });
  }

  Future<void> _processSale() async {
    setState(() => _isProcessingSale = true);
    try {
      // Crear la cabecera del comprobante
      final cabeceraData = {
  'tipo_comprobante': 'boleta',
  'serie_correlativo': '001-0001',
  'igv': 0.18,
  'pago_total': _total,
  'fecha': DateTime.now().toIso8601String(),
  'fk_sucursal': 1,
  'fk_usuario': 1,
};

      final cabeceraResponse = await ApiService.save('comprobante-cabecera', null, cabeceraData);
      final idComprobanteCabecera = cabeceraResponse['id_comprobante_cabecera'];

      // Crear los detalles del comprobante
            // ...existing code...
                                        // ...en _processSale()...
                    for (var item in _carrito) {
                      final Map<String, dynamic> detalleData = {};
                      detalleData['fk_producto_variante'] = item['id_producto_variante']; // <-- usa la variante
                      detalleData['cantidad'] = item['cantidad'];
                      detalleData['precio_producto'] = item['precio'];
                      detalleData['fk_comprobante_cabecera'] = idComprobanteCabecera;
                      await ApiService.save('comprobante-detalle', null, detalleData);
                    }
      // ...existing code...

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Venta realizada exitosamente')),
      );

      // Reiniciar el carrito
      setState(() {
        _carrito.clear();
        _total = 0.0;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al procesar la venta: $e')),
      );
    } finally {
      setState(() => _isProcessingSale = false);
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Realizar Venta')),
      body: Column(
        children: [
          Expanded(
            child: _isLoadingProductos
                ? const Center(child: CircularProgressIndicator())
                : _productos.isEmpty
                    ? const Center(child: Text('No hay variantes disponibles'))
                    : ListView.builder(
                        itemCount: _productos.length,
                        itemBuilder: (context, index) {
                          final producto = _productos[index];
                          return ListTile(
                            title: Text(producto['nombre']),
                            subtitle: Text(
  'Precio: \$${((double.tryParse(producto['precio_base'].toString()) ?? 0.0) + (double.tryParse(producto['precio_adicional'].toString()) ?? 0.0)).toStringAsFixed(2)} - '
  'Stock: ${producto['stock_actual']}'
),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () => _addToCart(index, -1),
                                ),
                                Text(
                                  (_carrito.firstWhere(
                                    (item) => item['id_producto_variante'] == producto['id_producto_variante'],
                                    orElse: () => <String, dynamic>{},
                                  )['cantidad'] ?? 0).toString(),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () => _addToCart(index, 1),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
          Card(
            margin: const EdgeInsets.all(16),
            child: Column(
              children: [
                ListTile(
                  title: const Text('Total'),
                  trailing: Text('\$${_total.toStringAsFixed(2)}'),
                ),
                const Divider(),
                ElevatedButton(
                  onPressed: _carrito.isEmpty ? null : _processSale,
                  child: _isProcessingSale
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(),
                        )
                      : const Text('Confirmar Venta'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
