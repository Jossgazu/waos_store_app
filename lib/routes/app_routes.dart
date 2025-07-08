import 'package:flutter/material.dart';
import 'package:waos_store_app/screen/configuration/form_screen.dart';
import 'package:waos_store_app/screen/dashboard_screen.dart';
import 'package:waos_store_app/screen/home_screen.dart';
import 'package:waos_store_app/screen/login_screen.dart';
import 'package:waos_store_app/screen/recover_password.dart';
import 'package:waos_store_app/screen/register_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String registro = '/register';
  static const String home = '/home';
  static const String recover = '/recover';
  static const String dashboard = '/dashboard';
  static const String form = '/form';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    registro: (context) => const RegisterScreen(),
    home: (context) {
      final args = ModalRoute.of(context)?.settings.arguments 
          as Map<String, dynamic>? ?? {'userRole': 'invitado'};
      return HomeScreen(userRole: args['userRole']);
    },
    recover: (context) => const RecoverScreen(),
    dashboard: (context) => const DashboardScreen(),
    form: (context) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      return FormScreen(
        title: args?['title'] ?? 'Formulario',
        endpoint: args?['endpoint'] ?? '',
        initialData: args?['item'],
      );
    },
  };

  static String initialRoute = login; // Cambiado a login como ruta inicial
}