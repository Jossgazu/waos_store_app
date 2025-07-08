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

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

    Future<void> _loadDashboardData() async {
      try {
        // Use getDataMap for stats, getData for lists
        final statsResponse = await ApiService.getDataMap('dashboard/stats');
        final ventasHoyResponse = await ApiService.getDataMap('dashboard/ventas/hoy');
        final ventasSemanaResponse = await ApiService.getDataMap('dashboard/ventas/semana');
        final productosMasVendidosResponse = await ApiService.getData('dashboard/productos/mas-vendidos');
        final ingresosTotalesResponse = await ApiService.getDataMap('dashboard/ingresos/total'); // <-- FIXED
        final ventasPorDiaResponse = await ApiService.getData('dashboard/ventas/por-dia');
  
        setState(() {
          _dashboardData = {
            'stats': statsResponse,
            'ventasHoy': ventasHoyResponse,
            'ventasSemana': ventasSemanaResponse,
            'productosMasVendidos': productosMasVendidosResponse,
            'ingresosTotales': ingresosTotalesResponse,
            'ventasPorDia': ventasPorDiaResponse,
          };
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar los datos del dashboard: $e')),
        );
      }
    }
  // ...existing code...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Estadísticas Generales
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Estadísticas Generales',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text('Ventas Hoy: \$${_dashboardData['ventasHoy'] != null && _dashboardData['ventasHoy']['total'] != null ? _dashboardData['ventasHoy']['total'] : 0}'),
                          Text('Ventas Semana: \$${_dashboardData['ventasSemana'] != null && _dashboardData['ventasSemana']['total'] != null ? _dashboardData['ventasSemana']['total'] : 0}'),
Text(
  'Ingresos Totales: \$${_dashboardData['ingresosTotales'] != null && _dashboardData['ingresosTotales']['ingresos_totales'] != null ? (_dashboardData['ingresosTotales']['ingresos_totales'] as num).toStringAsFixed(2) : '0.00'}',
),                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Productos Más Vendidos
                  Card(
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
                                                    ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: (_dashboardData['productosMasVendidos'] ?? []).length,
                            itemBuilder: (context, index) {
                              final producto = (_dashboardData['productosMasVendidos'] ?? [])[index];
                              return ListTile(
                                title: Text(producto['nombre']?.toString() ?? ''),
                                trailing: Text('\$${producto['total_ventas'] ?? 0}'),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Ventas Por Día
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ventas Por Día',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                                                    ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: (_dashboardData['ventasPorDia'] ?? []).length,
                            itemBuilder: (context, index) {
                              final ventaDia = (_dashboardData['ventasPorDia'] ?? [])[index];
                              return ListTile(
                                title: Text(ventaDia['fecha']?.toString() ?? ''),
                                trailing: Text('\$${ventaDia['total'] ?? 0}'),
                              );
                            },
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
