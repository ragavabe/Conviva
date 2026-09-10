import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../core/typography.dart';
import '../../core/state.dart';
import '../../models/app_user.dart';

class DriverSignupScreen extends StatefulWidget {
  const DriverSignupScreen({super.key});

  @override
  State<DriverSignupScreen> createState() => _DriverSignupScreenState();
}

class _DriverSignupScreenState extends State<DriverSignupScreen> {
  final _nameController = TextEditingController(text: 'Roberto Santos');
  final _codeController = TextEditingController(text: 'CONVIVA2026');
  final _emailController = TextEditingController(text: 'roberto@conviva.com');
  final _passwordController = TextEditingController(text: '123456');
  final _formKey = GlobalKey<FormState>();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final code = _codeController.text.trim().toUpperCase();
      if (code != 'CONVIVA2026' && code != 'CONVIVA') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Código de acesso inválido. Use CONVIVA2026 para demonstração.',
            ),
            backgroundColor: ConvivaColors.terracotta,
          ),
        );
        return;
      }
      final user = AppUser(
        id: 'driver_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        accessCode: code,
        email: _emailController.text.trim(),
        role: UserRole.driver,
      );
      ConvivaState.instance.login(user);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Motorista')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Motorista Parceiro Solidário',
                style: ConvivaTypography.titleSerifMedium,
              ),
              const SizedBox(height: 6),
              const Text(
                'Ajude a transportar pessoas idosas com segurança e conforto até os encontros.',
                style: ConvivaTypography.bodyMedium,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(fontSize: 17),
                decoration: const InputDecoration(
                  labelText: 'Nome completo',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (v) => v!.isEmpty ? 'Informe seu nome' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _codeController,
                style: const TextStyle(fontSize: 17),
                decoration: const InputDecoration(
                  labelText: 'Código de Acesso do Sistema',
                  helperText: 'Código do administrador (Ex: CONVIVA2026)',
                  prefixIcon: Icon(Icons.vpn_key_outlined),
                ),
                validator: (v) =>
                    v!.isEmpty ? 'Informe o código de acesso' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(fontSize: 17),
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (v) => v!.isEmpty ? 'Informe o e-mail' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(fontSize: 17),
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                validator: (v) => v!.isEmpty ? 'Crie uma senha' : null,
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ConvivaColors.ochre,
                ),
                child: const Text('Entrar / Cadastrar Motorista'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
