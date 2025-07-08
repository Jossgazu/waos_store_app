import 'package:flutter/material.dart';
import 'package:waos_store_app/services/api_service.dart';

class CrudScreen extends StatefulWidget {
  final String title;
  final String endpoint;

  const CrudScreen({Key? key, required this.title, required this.endpoint}) : super(key: key);

  @override
  State<CrudScreen> createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen> {
  List<dynamic> _items = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    if (!mounted) return; // Verificar si el widget está montado
    setState(() => _isLoading = true);
    
    try {
      final data = await ApiService.getData(widget.endpoint);
      if (mounted) { // Verificar antes de llamar setState
        setState(() {
          _items = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) { // Verificar antes de llamar setState
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar datos: $e'))
        );
      }
    }
  }

  void _goToCreateForm() async {
    final result = await Navigator.pushNamed(context, '/form', arguments: {
      'title': 'Agregar ${widget.title}',
      'endpoint': widget.endpoint,
      'method': 'POST',
    });
    
    // Si se creó exitosamente, recargar datos
    if (result == true && mounted) {
      _loadData();
    }
  }

  void _goToEditForm(int id, Map<String, dynamic> item) async {
  final result = await Navigator.pushNamed(context, '/form', arguments: {
    'title': 'Editar ${widget.title}',
    'endpoint': widget.endpoint,
    'method': 'PUT',
    'item': {
      ...item,
      'id': id, // Ensure ID is properly set
    },
  });
  
  // Si se editó exitosamente, recargar datos
  if (result == true && mounted) {
    _loadData();
  }
}

  void _deleteItem(int id) async {
    try {
      await ApiService.deleteData(widget.endpoint, id);
      if (mounted) {
        _loadData(); // Recargar lista
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Elemento eliminado exitosamente'))
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar: $e'))
        );
      }
    }
  }

  String _getIdFieldForEndpoint(String endpoint) {
  switch (endpoint) {
    case 'categoria':
      return 'id_categoria';
    case 'producto':
      return 'id_producto';
    case 'usuario':
      return 'id_usuario';
    case 'sucursal':
      return 'id_sucursal';
    case 'proveedor':
      return 'id_proveedor';
    case 'metodo-pago':
      return 'id_metodo_pago';
    case 'empresa':
      return 'id_empresa';
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

  @override
Widget build(BuildContext context) {
  final idField = _getIdFieldForEndpoint(widget.endpoint);

  return Scaffold(
    appBar: AppBar(title: Text(widget.title)),
    floatingActionButton: FloatingActionButton(
      onPressed: _goToCreateForm,
      child: const Icon(Icons.add),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lista de ${widget.title}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_items.isEmpty)
            const Center(
              child: Text(
                'No hay elementos para mostrar',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (_, i) {
                  final item = _items[i];
                  final id = item[idField]; // <-- usa el campo correcto
                  final name = item['nombre'] ?? 'Sin nombre';
                  final description = item['descripcion'] ?? '';
                  final isActive = item['activo'] ?? false;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (description.isNotEmpty) Text(description),
                          Text('ID: $id'),
                          Row(
                            children: [
                              Text('Estado: '),
                              Icon(
                                isActive ? Icons.check_circle : Icons.cancel,
                                color: isActive ? Colors.green : Colors.red,
                                size: 16,
                              ),
                              Text(isActive ? 'Activo' : 'Inactivo'),
                            ],
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: id != null ? () => _goToEditForm(id, item) : null,
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: id != null
                                ? () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text('Eliminar'),
                                        content: Text('¿Estás seguro de eliminar "$name"?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(),
                                            child: const Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              _deleteItem(id);
                                            },
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.red,
                                            ),
                                            child: const Text('Eliminar'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                : null,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    ),
  );
}
}