import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../core/typography.dart';
import '../../core/state.dart';
import '../../models/app_user.dart';
import '../../core/services/facebook_auth_service.dart';
import 'senior_signup_screen.dart';
import 'organizer_signup_screen.dart';
import 'driver_signup_screen.dart';

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
      final state = ConvivaState.instance;

      if (email.contains('carlos') || email.contains('org')) {
        state.switchRole(UserRole.organizer);
      } else if (email.contains('roberto') ||
          email.contains('mot') ||
          email.contains('motorista')) {
        state.switchRole(UserRole.driver);
      } else {
        state.switchRole(UserRole.senior);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Bem-vindo(a) de volta ao CONVIVA!',
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: ConvivaColors.pineGreen,
        ),
      );
    }
  }

  Future<void> _handleFacebookLogin() async {
    // Permite escolher o papel desejado ao entrar com Facebook
    final selectedRole = await showModalBottomSheet<UserRole>(
      context: context,
      backgroundColor: ConvivaColors.background,
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
                  color: ConvivaColors.border,
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
                  style: ConvivaTypography.titleSerifMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Escolha com qual perfil você gostaria de acessar o aplicativo:',
              style: ConvivaTypography.bodyMedium,
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: ConvivaColors.pineGreenLight,
                child: Icon(Icons.person, color: ConvivaColors.pineGreen),
              ),
              title: const Text('Usuário / Idoso (Padrão)', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Descobrir eventos e interagir'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: ConvivaColors.border),
              ),
              tileColor: Colors.white,
              onTap: () => Navigator.pop(ctx, UserRole.senior),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: ConvivaColors.terracottaLight,
                child: Icon(Icons.event, color: ConvivaColors.terracotta),
              ),
              title: const Text('Organizador de Eventos', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Criar e gerenciar atividades'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: ConvivaColors.border),
              ),
              tileColor: Colors.white,
              onTap: () => Navigator.pop(ctx, UserRole.organizer),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: ConvivaColors.ochreLight,
                child: Icon(Icons.directions_car, color: ConvivaColors.ochre),
              ),
              title: const Text('Motorista Solidário', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Oferecer transporte aos participantes'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: ConvivaColors.border),
              ),
              tileColor: Colors.white,
              onTap: () => Navigator.pop(ctx, UserRole.driver),
            ),
          ],
        ),
      ),
    );

    if (selectedRole == null) return;

    setState(() => _isFacebookLoading = true);
    try {
      final result = await FacebookAuthService.instance.login(role: selectedRole);

      if (!mounted) return;

      if (result.isSuccess && result.user != null) {
        ConvivaState.instance.login(result.user!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Bem-vindo(a), ${result.user!.name}!',
              style: const TextStyle(fontSize: 16),
            ),
            backgroundColor: ConvivaColors.pineGreen,
          ),
        );
      } else if (result.isCancelled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login com Facebook cancelado.'),
          ),
        );
      } else if (result.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.errorMessage!),
            backgroundColor: ConvivaColors.terracotta,
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
    showModalBottomSheet(
      context: context,
      backgroundColor: ConvivaColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: ConvivaColors.border,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Escolha seu perfil no CONVIVA',
              textAlign: TextAlign.center,
              style: ConvivaTypography.titleSerifMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Cada perfil possui uma experiência adaptada às suas necessidades.',
              textAlign: TextAlign.center,
              style: ConvivaTypography.bodyMedium,
            ),
            const SizedBox(height: 24),
            _buildRoleSelectionTile(
              title: 'Usuário / Idoso',
              description:
                  'Descobrir eventos, interagir e solicitar transporte',
              icon: Icons.person_rounded,
              color: ConvivaColors.pineGreen,
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SeniorSignupScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildRoleSelectionTile(
              title: 'Organizador de Eventos',
              description: 'Criar atividades, divulgar e gerenciar presença',
              icon: Icons.event_available_rounded,
              color: ConvivaColors.terracotta,
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OrganizerSignupScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildRoleSelectionTile(
              title: 'Motorista Solidário',
              description: 'Apoiar na mobilidade e levar idosos aos eventos',
              icon: Icons.directions_car_filled_rounded,
              color: ConvivaColors.ochre,
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DriverSignupScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleSelectionTile({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: ConvivaColors.border, width: 1.2),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: ConvivaColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: ConvivaColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: ConvivaColors.textSecondary,
            ),
          ],
        ),
      ),
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
                        color: ConvivaColors.pineGreen,
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
                      color: ConvivaColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Card de Demonstração Rápida para o Hackathon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ConvivaColors.pineGreenLight,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: ConvivaColors.pineGreen.withValues(alpha: 0.3),
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
                              color: ConvivaColors.pineGreen,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Acesso Rápido de Demonstração:',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: ConvivaColors.pineGreenText,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _buildQuickLoginChip(
                                label: '👵 Idosa',
                                onTap: () => ConvivaState.instance.switchRole(
                                  UserRole.senior,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildQuickLoginChip(
                                label: '📋 Organizador',
                                onTap: () => ConvivaState.instance.switchRole(
                                  UserRole.organizer,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildQuickLoginChip(
                                label: '🚗 Motorista',
                                onTap: () => ConvivaState.instance.switchRole(
                                  UserRole.driver,
                                ),
                              ),
                            ),
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
                        color: ConvivaColors.textSecondary,
                      ),
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Informe seu e-mail' : null,
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
                        color: ConvivaColors.textSecondary,
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
                      onPressed: _isFacebookLoading ? null : _handleFacebookLogin,
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
                    children: const [
                      Expanded(child: Divider(color: ConvivaColors.border)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'ou',
                          style: TextStyle(
                            color: ConvivaColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: ConvivaColors.border)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: _showSignupOptionsModal,
                    child: const Text('Criar nova conta'),
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
          border: Border.all(
            color: ConvivaColors.pineGreen.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: ConvivaColors.pineGreenText,
          ),
        ),
      ),
    );
  }
}
