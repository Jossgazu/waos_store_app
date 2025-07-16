import 'package:flutter/material.dart';
import 'package:waos_store_app/services/api_service.dart';

class CrudScreen extends StatefulWidget {
  final String title;
  final String endpoint;

  const CrudScreen({Key? key, required this.title, required this.endpoint})
    : super(key: key);

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
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final data = await ApiService.getData(widget.endpoint);
      if (mounted) {
        setState(() {
          _items = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al cargar datos: $e')));
      }
    }
  }

  void _goToCreateForm() async {
    final result = await Navigator.pushNamed(
      context,
      '/form',
      arguments: {
        'title': 'Agregar ${widget.title}',
        'endpoint': widget.endpoint,
        'method': 'POST',
      },
    );

    if (result == true && mounted) {
      _loadData();
    }
  }

  void _goToEditForm(int id, Map<String, dynamic> item) async {
    final result = await Navigator.pushNamed(
      context,
      '/form',
      arguments: {
        'title': 'Editar ${widget.title}',
        'endpoint': widget.endpoint,
        'method': 'PUT',
        'item': {...item, 'id': id},
      },
    );

    if (result == true && mounted) {
      _loadData();
    }
  }

  void _deleteItem(int id) async {
    try {
      await ApiService.deleteData(widget.endpoint, id);
      if (mounted) {
        _loadData();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Elemento eliminado exitosamente')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al eliminar: $e')));
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
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToCreateForm,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.add),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueAccent.withOpacity(0.1), Colors.grey[50]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lista de ${widget.title}',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.blueAccent,
                    ),
                  ),
                )
              else if (_items.isEmpty)
                Center(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'No hay elementos para mostrar',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (_, i) {
                      final item = _items[i];
                      final id = item[idField];
                      final name = item['nombre'] ?? 'Sin nombre';
                      final description = item['descripcion'] ?? '';
                      final isActive = item['activo'] ?? false;

                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          title: Text(
                            name,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (description.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 4,
                                    bottom: 4,
                                  ),
                                  child: Text(
                                    description,
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                ),
                              Text(
                                'ID: $id',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    'Estado: ',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                  Icon(
                                    isActive
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color: isActive ? Colors.green : Colors.red,
                                    size: 16,
                                  ),
                                  Text(
                                    isActive ? 'Activo' : 'Inactivo',
                                    style: TextStyle(
                                      color: isActive
                                          ? Colors.green
                                          : Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: id != null
                                    ? () => _goToEditForm(id, item)
                                    : null,
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: id != null
                                    ? () {
                                        showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: const Text(
                                              'Confirmar eliminación',
                                            ),
                                            content: Text(
                                              '¿Estás seguro de eliminar "$name"?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
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
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
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
      ),
    );
  }
}
