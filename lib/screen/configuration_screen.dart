import 'package:flutter/material.dart';
import 'package:waos_store_app/screen/configuration/business_configuration_screen.dart';
import 'package:waos_store_app/screen/configuration/dashboard/comprobantes_descargar_screen.dart';
import 'package:waos_store_app/screen/configuration/dashboard/comprobantes_hoy_screen.dart';
import 'package:waos_store_app/screen/configuration/dashboard/comprobantes_mes_screen.dart';
import 'package:waos_store_app/screen/configuration/dashboard/comprobantes_por_meses_screen.dart'; // Importa la nueva pantalla

class ConfigurationScreen extends StatefulWidget {
  const ConfigurationScreen({Key? key}) : super(key: key);

  @override
  State<ConfigurationScreen> createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  void _goToConfiguracionEmpresa() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BusinessConfigurationScreen(),
      ),
    );
  }

  void _goToComprobantesDescargar() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ComprobanteDescargarScreen(),
      ),
    );
  }

  void _goToComprobantesHoy() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ComprobantesHoyScreen(),
      ),
    );
  }

  void _goToComprobantesMes() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ComprobantesMesScreen(),
      ),
    );
  }

  void _goToComprobantesPorMeses() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ComprobantesPorMesesScreen(),
      ),
    );
  }

  void _logout() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Configuraciones',
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                'Administración',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[800],
                ),
              ),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.business,
                        color: Colors.blueAccent,
                      ),
                      title: const Text(
                        'Configuración de Empresa',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        'Administrar la configuración de tu empresa',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      onTap: _goToConfiguracionEmpresa,
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: const Icon(
                        Icons.logout,
                        color: Colors.redAccent,
                      ),
                      title: const Text(
                        'Cerrar Sesión',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        'Salir de tu cuenta actual',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      onTap: _logout,
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.download,
                        color: Colors.blueAccent,
                      ),
                      title: const Text(
                        'Descargar Comprobantes Por Rangos',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        'Descargar comprobantes por ID',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      onTap: _goToComprobantesDescargar,
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: const Icon(
                        Icons.receipt_long,
                        color: Colors.blueAccent,
                      ),
                      title: const Text(
                        'Comprobantes Hoy',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        'Ver comprobantes generados hoy',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      onTap: _goToComprobantesHoy,
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: const Icon(
                        Icons.date_range,
                        color: Colors.blueAccent,
                      ),
                      title: const Text(
                        'Comprobantes por Meses',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        'Ver comprobantes agrupados por meses',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      onTap: _goToComprobantesPorMeses,
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: const Icon(
                        Icons.calendar_month,
                        color: Colors.blueAccent,
                      ),
                      title: const Text(
                        'Descargar Comprobantes Por Meses',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        'Ver comprobantes generados este mes',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      onTap: _goToComprobantesMes,
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.blueGrey,
                      ),
                    ),
                    
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}