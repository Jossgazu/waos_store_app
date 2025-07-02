import 'package:flutter/material.dart';
import 'package:waos_store_app/routes/app_routes.dart';
import 'package:waos_store_app/screen/register_screen.dart';
import 'package:waos_store_app/services/auth_service.dart';
import 'package:waos_store_app/utils/validations.dart';
import 'package:waos_store_app/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() == true) {
      String email = _emailController.text;
      String password = _passwordController.text;
      print('Email: $email, PassWappalyzerword: $password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Campo Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo Electrónico',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu correo';
                  }
                  if (!value.contains('@')) {
                    return 'Correo inválido';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Campo Contraseña
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: const OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu contraseña';
                  }
                  if (value.length < 6) {
                    return 'La contraseña debe tener al menos 6 caracteres';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Botón de inicio de sesión
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Aquí iría la lógica de autenticación con Firebase
                    print('Email: ${_emailController.text}');
                    print('Password: ${_passwordController.text}');
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Iniciar Sesión'),
              ),

              const SizedBox(height: 16),
							// Boton de Olvido Contrasena
							ElevatedButton(onPressed: () {
								Navigator.pushNamed(context, AppRoutes.recover);
							}, 
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.orangeAccent.shade400,
                foregroundColor: Colors.white
              ),
							child: Text("Olvide Contrasena")),

              const SizedBox(height: 16),

              // Boton de Registrarse
							ElevatedButton(onPressed: () {
								Navigator.pushNamed(context, AppRoutes.registro);
							},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
							child: Text("Registro"))
            ],
          ),
        ),
      ),
    );
  }
}