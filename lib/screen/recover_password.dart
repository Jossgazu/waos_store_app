import 'package:flutter/material.dart';

class RecoverScreen extends StatefulWidget {
  const RecoverScreen({super.key});

  @override
  State<RecoverScreen> createState() => _RecoverScreenState();
}

class _RecoverScreenState extends State<RecoverScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Recuperar Contrasena"),),
      body: Padding(padding: const EdgeInsets.all(16.0)),
    );
  }
}