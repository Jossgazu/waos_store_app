import 'package:flutter/material.dart';
import 'package:waos_store_app/screen/configuration_screen.dart';
import 'package:waos_store_app/screen/dashboard_screen.dart';
import 'package:waos_store_app/screen/sales_screen.dart';
import 'package:waos_store_app/screen/store_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    SalesScreen(),
    StoreScreen(),
    ConfigurationScreen(),
  ];

  final List<BottomNavigationBarItem> _bottomItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
    BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Ventas'),
    BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Inventario'),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Configuración'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waos Store'),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: _bottomItems,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed, // Muestra todas las etiquetas
      ),
    );
  }
}