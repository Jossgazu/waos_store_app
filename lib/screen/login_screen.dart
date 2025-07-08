import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:waos_store_app/routes/app_routes.dart';
import 'package:waos_store_app/screen/auth/auth_service.dart';
import 'package:waos_store_app/screen/auth/user_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dniController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _dniController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
  if (_formKey.currentState?.validate() != true) return;

  setState(() => _isLoading = true);
  
  try {
    final response = await AuthService.login(
      _dniController.text.trim(),
      _passwordController.text.trim(),
    );

    // Guardar token en Hive
    final authBox = Hive.box('authBox');
    await authBox.put('token', response['access_token']);

    // Obtener datos completos del usuario
    final userData = await UserService.getUserByDni(_dniController.text.trim());
    
    // Guardar datos importantes del usuario
    await authBox.put('userData', userData);

    // Navegar a home
    Navigator.pushReplacementNamed(context, AppRoutes.home);
    
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}

  void _showErrorSnackbar(BuildContext context, dynamic error) {
    String errorMessage = 'Error de autenticación';
    
    if (error is String) {
      errorMessage = error;
    } else if (error is Map<String, dynamic>) {
      errorMessage = error['message'] ?? 'Error desconocido';
    } else if (error.toString().contains('SocketException')) {
      errorMessage = 'Error de conexión. Verifique su internet';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Form(
            key: _formKey,
            child: AutofillGroup(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildLogo(),
                  const SizedBox(height: 40),
                  _buildDniField(),
                  const SizedBox(height: 20),
                  _buildPasswordField(),
                  const SizedBox(height: 24),
                  _buildLoginButton(),
                  const SizedBox(height: 16),
                  _buildForgotPasswordLink(),
                  const SizedBox(height: 30),
                  _buildDivider(),
                  const SizedBox(height: 20),
                  _buildRegisterButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Hero(
      tag: 'app-logo',
      child: Image.asset(
        'assets/images/logo.png',
        height: 120,
        filterQuality: FilterQuality.high,
      ),
    );
  }

  Widget _buildDniField() {
    return TextFormField(
      controller: _dniController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.username],
      decoration: const InputDecoration(
        labelText: 'DNI',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.credit_card),
        hintText: 'Ingrese su DNI',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Ingrese su DNI';
        if (value.length < 8) return 'DNI debe tener 8 dígitos';
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.password],
      onFieldSubmitted: (_) => _submitForm(),
      decoration: InputDecoration(
        labelText: 'Contraseña',
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        hintText: 'Ingrese su contraseña',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Ingrese su contraseña';
        if (value.length < 6) return 'Mínimo 6 caracteres';
        return null;
      },
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _submitForm,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: _isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Text(
              'INICIAR SESIÓN',
              style: TextStyle(fontSize: 16),
            ),
    );
  }

  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.recover),
        child: const Text(
          '¿Olvidaste tu contraseña?',
          style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Row(
      children: [
        Expanded(child: Divider(thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('O', style: TextStyle(color: Colors.grey)),
        ),
        Expanded(child: Divider(thickness: 1)),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return OutlinedButton(
      onPressed: () => Navigator.pushNamed(context, AppRoutes.registro),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: const BorderSide(color: Colors.blue),
      ),
      child: const Text(
        'CREAR UNA CUENTA',
        style: TextStyle(
          fontSize: 16,
          color: Colors.blue,
        ),
      ),
    );
  }
}