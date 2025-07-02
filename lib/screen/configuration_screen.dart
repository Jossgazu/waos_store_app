import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waos_store_app/screen/configuration/business_configuration_screen.dart'; 

class ConfigurationScreen extends StatefulWidget {
  const ConfigurationScreen({Key? key}) : super(key: key);

  @override
  State<ConfigurationScreen> createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  bool _darkMode = false;

  void _toggleTheme() {
    setState(() {
      _darkMode = !_darkMode;
    });
    // Aquí puedes integrar el cambio real del tema más adelante
  }

//   Future<void> _abrirBackend() async {
//   final url = Uri.parse('http://10.0.2.2:8000');
//   // final url = Uri.parse('http://localhost:8000');
//   try {
//     bool canLaunch = await canLaunchUrl(url);
//     if (canLaunch) {
//       await launchUrl(
//         url,
//         mode: LaunchMode.externalApplication,
//       );
//     } else {
//       throw 'No se puede abrir $url';
//     }
//   } catch (e) {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error al abrir backend: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
// }
void _goToConfiguracionEmpresa() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const BusinessConfigurationScreen(),
    ),
  );
}


  void _logout() {
    // Aquí iremos a Login cuando integremos Firebase Auth
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuraciones'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Preferencias',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(_darkMode ? Icons.dark_mode : Icons.light_mode),
              title: Text(_darkMode ? 'Modo Oscuro' : 'Modo Claro'),
              trailing: Switch(
                value: _darkMode,
                onChanged: (value) => _toggleTheme(),
              ),
            ),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Administración',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.business),
              title: const Text('Configurar Empresa'),
              subtitle: const Text('Ir al backend para ajustes iniciales'),
              onTap: _goToConfiguracionEmpresa,
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            const Divider(),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar Sesión'),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }
}