import 'package:flutter/material.dart';
import 'package:waos_store_app/screen/login_screen.dart';
import 'package:waos_store_app/screen/recover_password.dart';
import 'package:waos_store_app/screen/register_screen.dart';
import 'package:waos_store_app/screen/configuration/form_screen.dart';
import 'package:waos_store_app/screen/dashboard_screen.dart';
import 'package:waos_store_app/screen/home_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String registro = '/registro';
  static const String home = '/home';
  static const String recover = '/recover';
  static const String dashboard = '/dashboard';
  static const String form = '/form';

  static final Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    registro: (context) => const RegisterScreen(),
    home: (context) => const HomeScreen(),
    recover: (context) => const RecoverScreen(),
    dashboard: (context) => const DashboardScreen(),
    form: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
      return FormScreen(
        title: args['title'] ?? 'Default Title',
        endpoint: args['endpoint'] ?? '/default-endpoint',
      );
    },
  };

  static const String initialRoute = login;
}