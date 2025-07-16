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
        SnackBar(
          content: Text('Error al cargar datos: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildStatCard(String title, dynamic value, IconData icon, Color color) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'S/${(value is num ? value : 0.0).toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadDashboardData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blueAccent.withOpacity(0.1),
                    Colors.grey[50]!,
                  ],
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Estadísticas Rápidas
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.5,
                      children: [
                        _buildStatCard(
                          'Ventas Hoy',
                          _dashboardData['ventasHoy']?['total_ventas'] ?? 0.0,
                          Icons.today,
                          Colors.blueAccent,
                        ),
                        _buildStatCard(
                          'Ventas Semana',
                          _dashboardData['ventasSemana']?['total_ventas'] ?? 0.0,
                          Icons.calendar_view_week,
                          Colors.greenAccent,
                        ),
                        _buildStatCard(
                          'Ventas Mes',
                          _dashboardData['ingresosMes']?['total_ingresos'] ?? 0.0,
                          Icons.monetization_on,
                          Colors.orangeAccent,
                        ),
                        _buildStatCard(
                          'Ventas Año',
                          _dashboardData['ingresosTotales']?['ingresos_totales'] ?? 0.0,
                          Icons.attach_money,
                          Colors.purpleAccent,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Gráfico de ventas últimos 12 meses
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ventas Último Año',
                              // 'Ventas Última Semana',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 200,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _ventasUltimoAnio.length,
                                itemBuilder: (context, index) {
                                  final ventaMes = _ventasUltimoAnio[index];
                                  final heightFactor = (ventaMes['total_ventas'] ?? 0.0) / 
                                      (_getMaxVenta(_ventasUltimoAnio) > 0 
                                          ? _getMaxVenta(_ventasUltimoAnio) 
                                          : 1);
                                  return Container(
                                    width: 80,
                                    margin: const EdgeInsets.only(right: 8),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'S/${(ventaMes['total_ventas'] ?? 0.0).toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Expanded(
                                          child: FractionallySizedBox(
                                            heightFactor: heightFactor,
                                            child: Container(
                                              width: 30,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Colors.blueAccent,
                                                    Colors.blueAccent.withOpacity(0.7),
                                                  ],
                                                ),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          ventaMes['nombre_mes_abreviado']?.toString() ?? 
                                              ventaMes['nombre_mes']?.toString().substring(0, 3) ?? '',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
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
                    ),
                    const SizedBox(height: 24),

                    // Ventas por mes (lista detallada)
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ventas por Mes',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (_ventasPorMes.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: Text(
                                    'No hay datos disponibles',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              )
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _ventasPorMes.length,
                                separatorBuilder: (_, __) => const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final ventaMes = _ventasPorMes[index];
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.blueAccent.withOpacity(0.1),
                                      child: Icon(
                                        Icons.calendar_month,
                                        size: 18,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                    title: Text(
                                      '${ventaMes['nombre_mes']} ${ventaMes['año']}',
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    subtitle: Text(
                                      'Transacciones: ${ventaMes['cantidad_ventas'] ?? 0}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    trailing: Text(
                                      'S/${(ventaMes['total_ventas'] ?? 0.0).toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Productos más vendidos
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Productos Más Vendidos',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,
                              ),
                            ),
                            const SizedBox(height: 16),
                            if ((_dashboardData['productosMasVendidos'] ?? []).isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: Text(
                                    'No hay datos disponibles',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              )
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: (_dashboardData['productosMasVendidos'] ?? []).length,
                                separatorBuilder: (_, __) => const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final producto = (_dashboardData['productosMasVendidos'] ?? [])[index];
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.greenAccent.withOpacity(0.1),
                                      child: Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                          color: Colors.greenAccent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      producto['nombre']?.toString() ?? 'Producto desconocido',
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    subtitle: Text(
                                      'Vendidos: ${producto['total_vendido'] ?? 0}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    // trailing: Text(
                                    //   'S/${(producto['total_ventas'] ?? 0.0).toStringAsFixed(2)}',
                                    //   style: const TextStyle(
                                    //     fontWeight: FontWeight.bold,
                                    //     color: Colors.greenAccent,
                                    //   ),
                                    // ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Ventas por día
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ventas por Día (Últimos 7 días)',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,
                              ),
                            ),
                            const SizedBox(height: 16),
                            if ((_dashboardData['ventasPorDia'] ?? []).isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: Text(
                                    'No hay datos disponibles',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              )
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: (_dashboardData['ventasPorDia'] ?? []).length,
                                separatorBuilder: (_, __) => const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final ventaDia = (_dashboardData['ventasPorDia'] ?? [])[index];
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.orangeAccent.withOpacity(0.1),
                                      child: Icon(
                                        Icons.calendar_today,
                                        size: 18,
                                        color: Colors.orangeAccent,
                                      ),
                                    ),
                                    title: Text(
                                      ventaDia['fecha']?.toString() ?? 'Fecha desconocida',
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    subtitle: Text(
                                      'Transacciones: ${ventaDia['cantidad_ventas'] ?? 0}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    trailing: Text(
                                      'S/${(ventaDia['total_ventas'] ?? 0.0).toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orangeAccent,
                                      ),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
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