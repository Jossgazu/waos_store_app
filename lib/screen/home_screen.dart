import 'package:flutter/material.dart';
import 'package:waos_store_app/screen/configuration_screen.dart';
import 'package:waos_store_app/screen/dashboard_screen.dart';
import 'package:waos_store_app/screen/sales_screen.dart';
import 'package:waos_store_app/screen/store_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userRole;

  const HomeScreen({super.key, required this.userRole});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late List<Widget> _availableScreens;
  late List<BottomNavigationBarItem> _availableBottomItems;

  @override
  void initState() {
    super.initState();
    _setupUIForRole();
  }

  void _setupUIForRole() {
    switch (widget.userRole.toLowerCase()) {
      case 'administrador':
        _availableScreens = const [
          DashboardScreen(),
          SalesScreen(),
          StoreScreen(),
          ConfigurationScreen(),
        ];
        _availableBottomItems = const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Ventas'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Inventario'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Configuración'),
        ];
        break;
      case 'vendedor':
        _availableScreens = const [SalesScreen()];
        _availableBottomItems = const [
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Ventas'),
        ];
        break;
      case 'proveedor':
        _availableScreens = const [StoreScreen()];
        _availableBottomItems = const [
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Inventario'),
        ];
        break;
      default:
        _availableScreens = const [DashboardScreen()];
        _availableBottomItems = const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        ];
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Waos Store')),
      body: _availableScreens[_currentIndex],
      bottomNavigationBar: _availableBottomItems.length > 1
          ? BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onItemTapped,
              items: _availableBottomItems,
              selectedItemColor: Colors.orange,
              unselectedItemColor: Colors.grey,
            )
          : null,
    );
  }
}