import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../core/typography.dart';
import '../../core/state.dart';
import '../../models/app_user.dart';

class OrganizerSignupScreen extends StatefulWidget {
  const OrganizerSignupScreen({super.key});

  @override
  State<OrganizerSignupScreen> createState() => _OrganizerSignupScreenState();
}

class _OrganizerSignupScreenState extends State<OrganizerSignupScreen> {
  final _nameController = TextEditingController(
    text: 'Centro Comunitário Jardim das Flores',
  );
  final _docController = TextEditingController(text: '12.345.678/0001-90');
  final _emailController = TextEditingController(
    text: 'contato@centrojardim.org',
  );
  final _passwordController = TextEditingController(text: '123456');
  final _formKey = GlobalKey<FormState>();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final user = AppUser(
        id: 'org_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        document: _docController.text.trim(),
        email: _emailController.text.trim(),
        role: UserRole.organizer,
      );
      ConvivaState.instance.login(user);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Organizador')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Promova Encontros Comunitários',
                style: ConvivaTypography.titleSerifMedium,
              ),
              const SizedBox(height: 6),
              const Text(
                'Cadastre sua entidade ou iniciativa para divulgar eventos para idosos.',
                style: ConvivaTypography.bodyMedium,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(fontSize: 17),
                decoration: const InputDecoration(
                  labelText: 'Nome do Responsável ou Entidade',
                  prefixIcon: Icon(Icons.business_outlined),
                ),
                validator: (v) => v!.isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _docController,
                style: const TextStyle(fontSize: 17),
                decoration: const InputDecoration(
                  labelText: 'CPF ou CNPJ',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                validator: (v) => v!.isEmpty ? 'Informe CPF ou CNPJ' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(fontSize: 17),
                decoration: const InputDecoration(
                  labelText: 'E-mail corporativo / institucional',
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
                  backgroundColor: ConvivaColors.terracotta,
                ),
                child: const Text('Criar conta de Organizador'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
