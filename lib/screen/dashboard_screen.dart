import 'package:flutter/material.dart';
import 'package:waos_store_app/services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = true;
  Map<String, dynamic> _dashboardData = {};
  List<dynamic> _ventasPorMes = [];
  List<dynamic> _ventasUltimoAnio = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
  try {
    final ventasHoy = await ApiService.getDataMap('dashboard/ventas/hoy');
    final ventasSemana = await ApiService.getDataMap('dashboard/ventas/semana');
    final ingresosMes = await ApiService.getDataMap('dashboard/ingresos/mes-actual');
    final productosMasVendidos = await ApiService.getData('dashboard/productos/mas-vendidos');
    final ingresosTotales = await ApiService.getDataMap('dashboard/ingresos/total');
    final ventasPorDia = await ApiService.getData('dashboard/ventas/por-dia');
    final ventasPorMes = await ApiService.getData('dashboard/ventas/por-mes');
    final ventasUltimoAnio = await ApiService.getData('dashboard/ventas/ultimo-anio');

    setState(() {
      _dashboardData = {
        'ventasHoy': ventasHoy,
        'ventasSemana': ventasSemana,
        'ingresosMes': ingresosMes,
        'productosMasVendidos': productosMasVendidos,
        'ingresosTotales': ingresosTotales,
        'ventasPorDia': ventasPorDia,
      };
      _ventasPorMes = ventasPorMes;
      _ventasUltimoAnio = ventasUltimoAnio;
      _isLoading = false;
    });
  } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar datos: $e')),
      );
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboardData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Resumen Estadístico
                  _buildResumenEstadistico(),
                  const SizedBox(height: 20),
                  
                  // Gráfico de ventas últimos 12 meses
                  _buildVentasUltimoAnio(),
                  const SizedBox(height: 20),
                  
                  // Ventas por mes (lista detallada)
                  _buildVentasPorMes(),
                  const SizedBox(height: 20),
                  
                  // Productos más vendidos
                  _buildProductosMasVendidos(),
                  const SizedBox(height: 20),
                  
                  // Ventas por día
                  _buildVentasPorDia(),
                ],
              ),
            ),
    );
  }

  Widget _buildResumenEstadistico() {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen Estadístico',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildStatItem(
            'Ventas Hoy', 
            _dashboardData['ventasHoy']?['total_ventas'] ?? 0.0,
            _dashboardData['ventasHoy']?['fecha'] ?? 'Fecha no disponible'
          ),
          _buildStatItem(
            'Ventas Semana', 
            _dashboardData['ventasSemana']?['total_ventas'] ?? 0.0,
            '${_dashboardData['ventasSemana']?['fecha_inicio'] ?? ''} a ${_dashboardData['ventasSemana']?['fecha_fin'] ?? ''}'
          ),
          _buildStatItem(
            'Ingresos Mes Actual', 
            _dashboardData['ingresosMes']?['total_ingresos'] ?? 0.0,
            '${_dashboardData['ingresosMes']?['nombre_mes'] ?? ''} ${_dashboardData['ingresosMes']?['año'] ?? ''}'
          ),
          _buildStatItem(
            'Ingresos Totales', 
            _dashboardData['ingresosTotales']?['ingresos_totales'] ?? 0.0,
            'Histórico acumulado'
          ),
        ],
      ),
    ),
  );
}

  Widget _buildVentasUltimoAnio() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ventas Último Año',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _ventasUltimoAnio.length,
                itemBuilder: (context, index) {
                  final ventaMes = _ventasUltimoAnio[index];
                  return Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          ventaMes['nombre_mes']?.toString() ?? '',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Expanded(
                          child: FractionallySizedBox(
                            heightFactor: (ventaMes['total_ventas'] ?? 0.0) / 
                                (_getMaxVenta(_ventasUltimoAnio) > 0 
                                    ? _getMaxVenta(_ventasUltimoAnio) 
                                    : 1),
                            child: Container(
                              width: 30,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${(ventaMes['total_ventas'] ?? 0.0).toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
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

  Widget _buildVentasPorMes() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ventas por Mes (Detalle)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (_ventasPorMes.isEmpty)
              const Text('No hay datos disponibles')
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _ventasPorMes.length,
                itemBuilder: (context, index) {
                  final ventaMes = _ventasPorMes[index];
                  return ListTile(
                    title: Text(
                      '${ventaMes['nombre_mes']} ${ventaMes['año']}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text('Transacciones: ${ventaMes['cantidad_ventas'] ?? 0}'),
                    trailing: Text(
                      '\$${(ventaMes['total_ventas'] ?? 0.0).toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductosMasVendidos() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Productos Más Vendidos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if ((_dashboardData['productosMasVendidos'] ?? []).isEmpty)
              const Text('No hay datos disponibles')
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: (_dashboardData['productosMasVendidos'] ?? []).length,
                itemBuilder: (context, index) {
                  final producto = (_dashboardData['productosMasVendidos'] ?? [])[index];
                  return ListTile(
                    leading: const Icon(Icons.shopping_basket),
                    title: Text(producto['nombre']?.toString() ?? 'Producto desconocido'),
                    subtitle: Text('Cantidad vendida: ${producto['total_vendido'] ?? 0}'),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVentasPorDia() {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ventas por Día (Últimos 7 días)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          if ((_dashboardData['ventasPorDia'] ?? []).isEmpty)
            const Text('No hay datos disponibles')
          else
            SizedBox(
              height: 300,
              child: ListView.builder(
                // Elimina el reverse: aquí ya no es necesario porque la lista ya viene invertida
                itemCount: (_dashboardData['ventasPorDia'] ?? []).length,
                itemBuilder: (context, index) {
                  final ventaDia = (_dashboardData['ventasPorDia'] ?? [])[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(ventaDia['fecha']?.toString() ?? 'Fecha desconocida'),
                      subtitle: Text('Transacciones: ${ventaDia['cantidad_ventas'] ?? 0}'),
                      trailing: Text(
                        '\$${(ventaDia['total_ventas'] ?? 0.0).toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
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


  Widget _buildStatItem(String title, dynamic value, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          if (subtitle.isNotEmpty)
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          Text(
            '\$${(value is num ? value : 0.0).toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  double _getMaxVenta(List<dynamic> ventas) {
    if (ventas.isEmpty) return 1.0;
    return ventas
        .map((v) => (v['total_ventas'] ?? 0.0) as double)
        .reduce((a, b) => a > b ? a : b);
  }
}