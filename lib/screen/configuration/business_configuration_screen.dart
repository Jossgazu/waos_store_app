import 'package:flutter/material.dart';
import 'package:waos_store_app/screen/configuration/crud_screen.dart';
import 'package:waos_store_app/services/api_service.dart';

class BusinessConfigurationScreen extends StatefulWidget {
  const BusinessConfigurationScreen({super.key});

  @override
  State<BusinessConfigurationScreen> createState() =>
      _BusinessConfigurationScreenState();
}

class _BusinessConfigurationScreenState
    extends State<BusinessConfigurationScreen> {
  // Estados de carga para cada entidad
  bool _isLoadingCategorias = false;
  List<dynamic> _categorias = [];

  bool _isLoadingProductos = false;
  List<dynamic> _productos = [];

  bool _isLoadingSucursales = false;
  List<dynamic> _sucursales = [];

  bool _isLoadingUsuarios = false;
  List<dynamic> _usuarios = [];

  bool _isLoadingProveedores = false;
  List<dynamic> _proveedores = [];

  bool _isLoadingMetodosPago = false;
  List<dynamic> _metodosPago = [];

  bool _isLoadingEmpresas = false;
  List<dynamic> _empresas = [];

  bool _isLoadingComprobantesCabecera = false;
  List<dynamic> _comprobantesCabecera = [];

  bool _isLoadingComprobantesDetalle = false;
  List<dynamic> _comprobantesDetalle = [];

  bool _isLoadingPagos = false;
  List<dynamic> _pagos = [];

  bool _isLoadingInventario = false;
  List<dynamic> _inventario = [];

  bool _isLoadingProductoVariante = false;
  List<dynamic> _productoVariante = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadCategorias(),
      _loadProductos(),
      _loadSucursales(),
      _loadUsuarios(),
      _loadProveedores(),
      _loadMetodosPago(),
      _loadEmpresas(),
      _loadComprobantesCabecera(),
      _loadComprobantesDetalle(),
      _loadPagos(),
      _loadInventario(),
      _loadProductoVariante(),
    ]);
  }

  Future<void> _loadCategorias() async {
    setState(() => _isLoadingCategorias = true);
    try {
      final data = await ApiService.getData('categoria');
      setState(() {
        _categorias = data;
        _isLoadingCategorias = false;
      });
    } catch (e) {
      setState(() => _isLoadingCategorias = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cargar categorías: $e')));
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cargar productos: $e')));
    }
  }

  Future<void> _loadSucursales() async {
    setState(() => _isLoadingSucursales = true);
    try {
      final data = await ApiService.getData('sucursal');
      setState(() {
        _sucursales = data;
        _isLoadingSucursales = false;
      });
    } catch (e) {
      setState(() => _isLoadingSucursales = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cargar sucursales: $e')));
    }
  }

  Future<void> _loadUsuarios() async {
    setState(() => _isLoadingUsuarios = true);
    try {
      final data = await ApiService.getData('usuario');
      setState(() {
        _usuarios = data;
        _isLoadingUsuarios = false;
      });
    } catch (e) {
      setState(() => _isLoadingUsuarios = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cargar usuarios: $e')));
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
        SnackBar(content: Text('Error al cargar proveedores: $e')),
      );
    }
  }

  Future<void> _loadMetodosPago() async {
    setState(() => _isLoadingMetodosPago = true);
    try {
      final data = await ApiService.getData('metodo-pago');
      setState(() {
        _metodosPago = data;
        _isLoadingMetodosPago = false;
      });
    } catch (e) {
      setState(() => _isLoadingMetodosPago = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar métodos de pago: $e')),
      );
    }
  }

  Future<void> _loadEmpresas() async {
    setState(() => _isLoadingEmpresas = true);
    try {
      final data = await ApiService.getData('empresa');
      setState(() {
        _empresas = data;
        _isLoadingEmpresas = false;
      });
    } catch (e) {
      setState(() => _isLoadingEmpresas = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cargar empresas: $e')));
    }
  }

  Future<void> _loadComprobantesCabecera() async {
    setState(() => _isLoadingComprobantesCabecera = true);
    try {
      final data = await ApiService.getData('comprobante-cabecera');
      setState(() {
        _comprobantesCabecera = data;
        _isLoadingComprobantesCabecera = false;
      });
    } catch (e) {
      setState(() => _isLoadingComprobantesCabecera = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar comprobantes de cabecera: $e')),
      );
    }
  }

  Future<void> _loadComprobantesDetalle() async {
    setState(() => _isLoadingComprobantesDetalle = true);
    try {
      final data = await ApiService.getData('comprobante-detalle');
      setState(() {
        _comprobantesDetalle = data;
        _isLoadingComprobantesDetalle = false;
      });
    } catch (e) {
      setState(() => _isLoadingComprobantesDetalle = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar comprobantes de detalle: $e')),
      );
    }
  }

  Future<void> _loadPagos() async {
    setState(() => _isLoadingPagos = true);
    try {
      final data = await ApiService.getData('pago');
      setState(() {
        _pagos = data;
        _isLoadingPagos = false;
      });
    } catch (e) {
      setState(() => _isLoadingPagos = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cargar pagos: $e')));
    }
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cargar inventario: $e')));
    }
  }

  Future<void> _loadProductoVariante() async {
    setState(() => _isLoadingProductoVariante = true);
    try {
      final data = await ApiService.getData('producto-variante');
      setState(() {
        _productoVariante = data;
        _isLoadingProductoVariante = false;
      });
    } catch (e) {
      setState(() => _isLoadingProductoVariante = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar producto variante: $e')),
      );
    }
  }

  void _navigateToCrud(BuildContext context, String endpoint) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CrudScreen(
          title: _getTitleFromEndpoint(endpoint),
          endpoint: endpoint,
        ),
      ),
    ).then((_) => _loadData());
  }

  String _getTitleFromEndpoint(String endpoint) {
    switch (endpoint) {
      case 'categoria':
        return 'Categoría';
      case 'producto':
        return 'Producto';
      case 'sucursal':
        return 'Sucursal';
      case 'usuario':
        return 'Usuario';
      case 'proveedor':
        return 'Proveedor';
      case 'metodo-pago':
        return 'Método de Pago';
      case 'empresa':
        return 'Empresa';
      case 'comprobante-cabecera':
        return 'Comprobante de Cabecera';
      case 'comprobante-detalle':
        return 'Comprobante de Detalle';
      case 'pago':
        return 'Pago';
      case 'inventario':
        return 'Inventario';
      case 'producto-variante':
        return 'Producto Variante';
      default:
        return endpoint;
    }
  }

  Widget _buildSection({
    required String title,
    required List<dynamic> items,
    required bool isLoading,
    required VoidCallback onCrudPressed,
    required String idField,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.blueGrey,
          ),
        ),
        collapsedBackgroundColor: Colors.grey[50],
        backgroundColor: Colors.white,
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
        children: [
          if (isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                ),
              ),
            )
          else if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                'No hay registros.',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            ...items.map(
              (item) => Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  title: Text(
                    item['nombre'] ?? item['id'].toString(),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    'ID: ${item[idField] ?? ''}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: onCrudPressed,
              icon: const Icon(Icons.settings, size: 18),
              label: const Text('Gestionar'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Configurar Empresa',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueAccent.withOpacity(0.1), Colors.grey[50]!],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSection(
              title: 'Categorías',
              items: _categorias,
              isLoading: _isLoadingCategorias,
              onCrudPressed: () => _navigateToCrud(context, 'categoria'),
              idField: 'id_categoria',
            ),
            _buildSection(
              title: 'Productos',
              items: _productos,
              isLoading: _isLoadingProductos,
              onCrudPressed: () => _navigateToCrud(context, 'producto'),
              idField: 'id_producto',
            ),
            _buildSection(
              title: 'Sucursales',
              items: _sucursales,
              isLoading: _isLoadingSucursales,
              onCrudPressed: () => _navigateToCrud(context, 'sucursal'),
              idField: 'id_sucursal',
            ),
            _buildSection(
              title: 'Usuarios',
              items: _usuarios,
              isLoading: _isLoadingUsuarios,
              onCrudPressed: () => _navigateToCrud(context, 'usuario'),
              idField: 'id_usuario',
            ),
            _buildSection(
              title: 'Proveedores',
              items: _proveedores,
              isLoading: _isLoadingProveedores,
              onCrudPressed: () => _navigateToCrud(context, 'proveedor'),
              idField: 'id_proveedor',
            ),
            _buildSection(
              title: 'Métodos de Pago',
              items: _metodosPago,
              isLoading: _isLoadingMetodosPago,
              onCrudPressed: () => _navigateToCrud(context, 'metodo-pago'),
              idField: 'id_metodo_pago',
            ),
            _buildSection(
              title: 'Empresas',
              items: _empresas,
              isLoading: _isLoadingEmpresas,
              onCrudPressed: () => _navigateToCrud(context, 'empresa'),
              idField: 'id_empresa',
            ),
            _buildSection(
              title: 'Comprobantes de Cabecera',
              items: _comprobantesCabecera,
              isLoading: _isLoadingComprobantesCabecera,
              onCrudPressed: () =>
                  _navigateToCrud(context, 'comprobante-cabecera'),
              idField: 'id_comprobante_cabecera',
            ),
            _buildSection(
              title: 'Comprobantes de Detalle',
              items: _comprobantesDetalle,
              isLoading: _isLoadingComprobantesDetalle,
              onCrudPressed: () =>
                  _navigateToCrud(context, 'comprobante-detalle'),
              idField: 'id_comprobante_detalle',
            ),
            _buildSection(
              title: 'Pagos',
              items: _pagos,
              isLoading: _isLoadingPagos,
              onCrudPressed: () => _navigateToCrud(context, 'pago'),
              idField: 'id_pago',
            ),
            _buildSection(
              title: 'Inventario',
              items: _inventario,
              isLoading: _isLoadingInventario,
              onCrudPressed: () => _navigateToCrud(context, 'inventario'),
              idField: 'id_inventario',
            ),
            _buildSection(
              title: 'Producto Variante',
              items: _productoVariante,
              isLoading: _isLoadingProductoVariante,
              onCrudPressed: () =>
                  _navigateToCrud(context, 'producto-variante'),
              idField: 'id_producto_variante',
            ),
          ],
        ),
      ),
    );
  }
}
