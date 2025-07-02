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
  bool _isLoadingCategorias = false;
  List<dynamic> _categorias = [];

  bool _isLoadingProductos = false;
  List<dynamic> _productos = [];

  bool _isLoadingSucursales = false;
  List<dynamic> _sucursales = [];

bool _isLoadingUsuarios = false;
List<dynamic> _usuarios = [];

bool _isLoadingRoles = false;
List<dynamic> _roles = [];

bool _isLoadingProveedores = false;
List<dynamic> _proveedores = [];

bool _isLoadingMetodosPago = false;
List<dynamic> _metodosPago = [];

bool _isLoadingEmpresas = false;
List<dynamic> _empresas = [];

bool _isLoadingComprobantesCabecera = false;
List<dynamic> _comprobantesCabecera = [];


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
    _loadRoles(),
    _loadProveedores(),
    _loadMetodosPago(),
    _loadEmpresas(),
    _loadComprobantesCabecera(),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar categorías: $e')),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar sucursales: $e')),
      );
    }
  }

  // Cargar Usuarios
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al cargar usuarios: $e')),
    );
  }
}

// Cargar Roles
Future<void> _loadRoles() async {
  setState(() => _isLoadingRoles = true);
  try {
    final data = await ApiService.getData('rol');
    setState(() {
      _roles = data;
      _isLoadingRoles = false;
    });
  } catch (e) {
    setState(() => _isLoadingRoles = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al cargar roles: $e')),
    );
  }
}

// Cargar Proveedores
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

// Cargar Métodos de Pago
Future<void> _loadMetodosPago() async {
  setState(() => _isLoadingMetodosPago = true);
  try {
    final data = await ApiService.getData('metodopago');
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

// Cargar Empresas
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al cargar empresas: $e')),
    );
  }
}

// Cargar Comprobantes de Cabecera
Future<void> _loadComprobantesCabecera() async {
  setState(() => _isLoadingComprobantesCabecera = true);
  try {
    final data = await ApiService.getData('comprobantecabecera');
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


  void _navigateToCrud(BuildContext context, String endpoint) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => CrudScreen(
        title: _getTitleFromEndpoint(endpoint),
        endpoint: endpoint,
      ),
    ),
  ).then((_) => _loadData()); // Recarga datos al volver
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
    case 'rol':
      return 'Rol';
    case 'proveedor':
      return 'Proveedor';
    case 'metodopago':
      return 'Método de Pago';
    case 'empresa':
      return 'Empresa';
    case 'comprobantecabecera':
      return 'Comprobante de Cabecera';
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
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: ExpansionTile(
      title: Text(title),
      childrenPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
      children: [
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else if (items.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text('No hay registros.'),
          )
        else
          ...items.map((item) => ListTile(
                title: Text(item['nombre'] ?? item['id'].toString()),
                subtitle: Text('ID: ${item[idField] ?? ''}'),
              )),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: onCrudPressed,
            icon: const Icon(Icons.settings),
            label: const Text('Gestionar'),
          ),
        ),
      ],
    ),
  );
}


  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Configurar Empresa')),
    body: ListView(
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
          title: 'Roles',
          items: _roles,
          isLoading: _isLoadingRoles,
          onCrudPressed: () => _navigateToCrud(context, 'rol'),
          idField: 'id_rol',
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
          onCrudPressed: () => _navigateToCrud(context, 'metodopago'),
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
          onCrudPressed: () => _navigateToCrud(context, 'comprobante-cabecera'),
          idField: 'id_comprobante_cabecera',
        ),
      ],
    ),
  );
}

}