import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../core/typography.dart';
import '../../core/state.dart';
import '../../models/app_user.dart';

class SeniorSignupScreen extends StatefulWidget {
  const SeniorSignupScreen({super.key});

  @override
  State<SeniorSignupScreen> createState() => _SeniorSignupScreenState();
}

class _SeniorSignupScreenState extends State<SeniorSignupScreen> {
  final _nameController = TextEditingController(text: 'Dona Marta');
  final _addressController = TextEditingController(
    text: 'Rua das Camélias, 120 - Jardim das Flores',
  );
  final _phoneController = TextEditingController(text: '(11) 98765-4321');
  final _emailController = TextEditingController(text: 'marta@conviva.com');
  final _passwordController = TextEditingController(text: '123456');
  final _formKey = GlobalKey<FormState>();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final user = AppUser(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        role: UserRole.senior,
      );
      ConvivaState.instance.login(user);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Usuário')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Boas-vindas ao CONVIVA!',
                style: ConvivaTypography.titleSerifMedium,
              ),
              const SizedBox(height: 6),
              const Text(
                'Preencha seus dados para encontrar eventos perto de você.',
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
                controller: _addressController,
                style: const TextStyle(fontSize: 17),
                decoration: const InputDecoration(
                  labelText: 'Endereço residencial',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                validator: (v) => v!.isEmpty ? 'Informe seu endereço' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontSize: 17),
                decoration: const InputDecoration(
                  labelText: 'Telefone / WhatsApp',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                validator: (v) => v!.isEmpty ? 'Informe seu telefone' : null,
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
                validator: (v) => v!.isEmpty ? 'Informe seu e-mail' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(fontSize: 17),
                decoration: const InputDecoration(
                  labelText: 'Senha de acesso',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                validator: (v) => v!.isEmpty ? 'Crie uma senha' : null,
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Criar conta e Começar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
