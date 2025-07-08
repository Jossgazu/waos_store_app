import 'package:flutter/material.dart';
import 'package:waos_store_app/services/api_service.dart';

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
      final variantsData = await ApiService.getData('producto-variante');
      final inventarioData = await ApiService.getData('inventario');

      List<dynamic> productosConStock = [];
      for (var variant in variantsData) {
        int variantId = variant['id_producto_variante'];
        final movimientos = inventarioData
            .where((inv) => inv['fk_producto_variante'] == variantId)
            .toList();
        int currentStock = 0;
        if (movimientos.isNotEmpty) {
          movimientos.sort(
            (a, b) => (b['id_inventario'] as int).compareTo(
              a['id_inventario'] as int,
            ),
          );
          currentStock = movimientos.first['stock_actual'] ?? 0;
        }
        variant['stock_actual'] = currentStock;
        productosConStock.add(variant);
      }

      setState(() {
        _productos = productosConStock;
        _isLoadingProductos = false;
      });
    } catch (e) {
      setState(() => _isLoadingProductos = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar productos: $e'),
          backgroundColor: Colors.red[700],
        ),
      );
    }
  }

  void _addToCart(int index, int cantidad) {
  final producto = _productos[index];
  int currentStock = producto['stock_actual'] ?? 0;

  int existingIndex = _carrito.indexWhere(
    (item) => item['id_producto_variante'] == producto['id_producto_variante'],
  );

  int currentCartQuantity = 0;
  if (existingIndex != -1) {
    currentCartQuantity = _carrito[existingIndex]['cantidad'];
  }

  int newQuantity = currentCartQuantity + cantidad;

  // No permitir cantidades menores a 0
  if (newQuantity < 0) return;

  // No permitir superar el stock
  if (newQuantity > currentStock) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Stock insuficiente. Disponible: $currentStock'),
        backgroundColor: Colors.orange[700],
      ),
    );
    return;
  }

  setState(() {
    if (existingIndex != -1) {
      if (newQuantity == 0) {
        _carrito.removeAt(existingIndex);
      } else {
        _carrito[existingIndex]['cantidad'] = newQuantity;
      }
    } else if (cantidad > 0) {
      _carrito.add({
        'id_producto_variante': producto['id_producto_variante'],
        'id_producto': producto['fk_producto'],
        'nombre': producto['nombre'],
        'precio':
            (double.tryParse(producto['precio_base'].toString()) ?? 0.0) +
            (double.tryParse(producto['precio_adicional'].toString()) ?? 0.0),
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
      total += (item['precio'] ?? 0.0) * (item['cantidad'] ?? 0);
    }
    setState(() {
      _total = total;
    });
  }

  Future<void> _processSale() async {
    setState(() => _isProcessingSale = true);
    try {
      final cabeceraData = {
        'tipo_comprobante': 'boleta',
        'serie_correlativo': '001-0001',
        'igv': 0.18,
        'pago_total': _total,
        'fecha': DateTime.now().toIso8601String(),
        'fk_sucursal': 1,
        'fk_usuario': 1,
      };

      final cabeceraResponse = await ApiService.save(
        'comprobante-cabecera',
        null,
        cabeceraData,
      );
      final idComprobanteCabecera = cabeceraResponse['id_comprobante_cabecera'];

      for (var item in _carrito) {
        final detalleData = {
          'fk_producto_variante': item['id_producto_variante'],
          'cantidad': item['cantidad'],
          'precio_producto': item['precio'],
          'fk_comprobante_cabecera': idComprobanteCabecera,
        };
        await ApiService.save('comprobante-detalle', null, detalleData);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Venta realizada exitosamente'),
          backgroundColor: Colors.green[700],
        ),
      );

      setState(() {
        _carrito.clear();
        _total = 0.0;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al procesar la venta: $e'),
          backgroundColor: Colors.red[700],
        ),
      );
    } finally {
      setState(() => _isProcessingSale = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Realizar Venta',
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
            Expanded(
              child: _isLoadingProductos
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blueAccent,
                        ),
                      ),
                    )
                  : _productos.isEmpty
                  ? Center(
                      child: Text(
                        'No hay productos disponibles',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: _productos.length,
                      itemBuilder: (context, index) {
                        final producto = _productos[index];
                        final precio =
                            (double.tryParse(
                                  producto['precio_base'].toString(),
                                ) ??
                                0.0) +
                            (double.tryParse(
                                  producto['precio_adicional'].toString(),
                                ) ??
                                0.0);
                        final stock = producto['stock_actual'] ?? 0;

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          elevation: 1,
                          child: ListTile(
                            title: Text(
                              producto['nombre'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Precio: S/${precio.toStringAsFixed(2)}',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                Text(
                                  'Stock: $stock',
                                  style: TextStyle(
                                    color: stock > 0
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  color: Colors.redAccent,
                                  onPressed: () => _addToCart(index, -1),
                                ),
                                Container(
                                  width: 24,
                                  alignment: Alignment.center,
                                  child: Text(
                                    (_carrito.firstWhere(
                                              (item) =>
                                                  item['id_producto_variante'] ==
                                                  producto['id_producto_variante'],
                                              orElse: () => <String, dynamic>{},
                                            )['cantidad'] ??
                                            0)
                                        .toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  color: Colors.greenAccent,
                                  onPressed: () => _addToCart(index, 1),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Card(
              margin: const EdgeInsets.all(16),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text(
                        'Total',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        'S/${_total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                    const Divider(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _carrito.isEmpty ? null : _processSale,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isProcessingSale
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'CONFIRMAR VENTA',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
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
