import 'package:flutter/material.dart';
import 'package:waos_store_app/routes/app_routes.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configurar Hive
  final appDocDir = await getApplicationSupportDirectory();
  Hive.init(p.join(appDocDir.path, 'waos_store_data'));
  await Hive.openBox('authBox');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Waos-Store',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: AppRoutes.initialRoute,
      routes: AppRoutes.routes,
    );
  }
}