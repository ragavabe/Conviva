import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/state/app_state.dart';
import '../../core/services/facebook_auth_service.dart';
import '../../models/pessoa.dart';
import '../../models/tipo_usuario.dart';
import 'login_flow.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'marta@conviva.com');
  final _passwordController = TextEditingController(text: '123456');
  final _formKey = GlobalKey<FormState>();
  bool _isFacebookLoading = false;

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim().toLowerCase();

      TipoUsuario tipo;
      if (email.contains('carlos') || email.contains('org')) {
        tipo = TipoUsuario.organizador;
      } else if (email.contains('roberto') ||
          email.contains('mot') ||
          email.contains('motorista')) {
        tipo = TipoUsuario.motorista;
      } else {
        tipo = TipoUsuario.usuario;
      }

      AppState.instance.login(
        Pessoa(
          nome: email.split('@').first,
          documento: 'DEMO-$email',
          tipo: tipo,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Bem-vindo(a) de volta ao CONVIVA!',
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: AppColors.verde,
        ),
      );
    }
  }

  Future<void> _handleFacebookLogin() async {
    // Permite escolher o papel desejado ao entrar com Facebook
    final selectedTipo = await showModalBottomSheet<TipoUsuario>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.textoSecundario.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: const [
                Icon(Icons.facebook, color: Color(0xFF1877F2), size: 28),
                SizedBox(width: 10),
                Text(
                  'Entrar com Facebook',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Escolha com qual perfil você gostaria de acessar o aplicativo:',
              style: TextStyle(fontSize: 14, color: AppColors.textoSecundario),
            ),
            const SizedBox(height: 20),
            for (final tipo in TipoUsuario.values)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: tipo.cor.withValues(alpha: 0.15),
                    child: Icon(tipo.icone, color: tipo.cor),
                  ),
                  title: Text(
                    tipo.label,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(tipo.descricao),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: tipo.cor.withValues(alpha: 0.3)),
                  ),
                  tileColor: Colors.white,
                  onTap: () => Navigator.pop(ctx, tipo),
                ),
              ),
          ],
        ),
      ),
    );

    if (selectedTipo == null) return;

    setState(() => _isFacebookLoading = true);
    try {
      final result = await FacebookAuthService.instance.login(
        tipo: selectedTipo,
      );

      if (!mounted) return;

      if (result.isSuccess && result.pessoa != null) {
        AppState.instance.login(result.pessoa!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Bem-vindo(a), ${result.pessoa!.nome}!',
              style: const TextStyle(fontSize: 16),
            ),
            backgroundColor: AppColors.verde,
          ),
        );
      } else if (result.isCancelled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login com Facebook cancelado.')),
        );
      } else if (result.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.errorMessage!),
            backgroundColor: AppColors.laranja,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isFacebookLoading = false);
      }
    }
  }

  void _showSignupOptionsModal() {
    // As telas de cadastro por tipo (idoso/organizador/motorista) já existem
    // no fluxo EscolhaTipoPage -> FormularioPage, então reaproveitamos o LoginFlow.
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginFlow()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo / Marca CONVIVA
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.verde,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.favorite_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'CONVIVA',
                            style: TextStyle(
                              fontFamily: 'serif',
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Conectando pessoas.\nMovendo vidas.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.texto,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Card de Demonstração Rápida para o Hackathon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.verde.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: AppColors.verde.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.touch_app_rounded,
                              size: 20,
                              color: AppColors.verde,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Acesso Rápido de Demonstração:',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.verdeEscuro,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            for (final tipo in TipoUsuario.values) ...[
                              Expanded(
                                child: _buildQuickLoginChip(
                                  label: switch (tipo) {
                                    TipoUsuario.usuario => '👵 Idosa',
                                    TipoUsuario.organizador => '📋 Organizador',
                                    TipoUsuario.motorista => '🚗 Motorista',
                                  },
                                  onTap: () => AppState.instance.login(
                                    Pessoa(
                                      nome: 'Demo ${tipo.label}',
                                      documento: 'DEMO-${tipo.name}',
                                      tipo: tipo,
                                    ),
                                  ),
                                ),
                              ),
                              if (tipo != TipoUsuario.values.last)
                                const SizedBox(width: 8),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Campos de Login Tradicionais
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(fontSize: 17),
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: AppColors.textoSecundario,
                      ),
                    ),
                    validator: (val) => val == null || val.isEmpty
                        ? 'Informe seu e-mail'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(fontSize: 17),
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: Icon(
                        Icons.lock_outline_rounded,
                        color: AppColors.textoSecundario,
                      ),
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Informe sua senha' : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _handleLogin,
                    child: const Text('Entrar'),
                  ),
                  const SizedBox(height: 14),

                  // Botão Conectar com Facebook
                  SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _isFacebookLoading
                          ? null
                          : _handleFacebookLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1877F2),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: _isFacebookLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.facebook, size: 22),
                      label: Text(
                        _isFacebookLoading
                            ? 'Conectando ao Facebook...'
                            : 'Continuar com Facebook',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: AppColors.textoSecundario.withValues(
                            alpha: 0.3,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'ou',
                          style: TextStyle(
                            color: AppColors.textoSecundario,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: AppColors.textoSecundario.withValues(
                            alpha: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: _showSignupOptionsModal,
                    child: const Text('Criar nova conta'),
                  ),
                  const SizedBox(height: 24),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                          title: Row(
                            children: const [
                              Icon(
                                Icons.support_agent_rounded,
                                color: AppColors.verde,
                                size: 28,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Apoio ao Usuário',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          content: const Text(
                            'Olá! Se você tiver qualquer dúvida ou dificuldade para entrar no aplicativo, nosso time comunitário está pronto para te apoiar com todo carinho:\n\n📞 Telefone / WhatsApp: (11) 98765-4321',
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.texto,
                              height: 1.45,
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () => Navigator.pop(ctx),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.verde,
                              ),
                              child: const Text('Entendi, obrigado! ✨'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.help_outline_rounded,
                            size: 18,
                            color: AppColors.textoSecundario,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Precisa de ajuda para entrar? Toque aqui',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textoSecundario,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickLoginChip({
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.verde.withValues(alpha: 0.3)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.verdeEscuro,
          ),
        ),
      ),
    );
  }
}
