import 'package:flutter/material.dart';
import 'package:waos_store_app/routes/app_routes.dart';


void main() async {
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