import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../core/typography.dart';
import '../../core/state.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/app_user.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = ConvivaState.instance;

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final user = state.currentUser;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Meu Perfil'),
            automaticallyImplyLeading: false,
          ),
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // Card de Usuário
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 46,
                      backgroundColor: ConvivaColors.pineGreenLight,
                      backgroundImage: user?.pictureUrl != null
                          ? NetworkImage(user!.pictureUrl!)
                          : null,
                      child: user?.pictureUrl == null
                          ? Text(
                              user?.initials ?? 'CO',
                              style: const TextStyle(
                                fontFamily: 'serif',
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: ConvivaColors.pineGreen,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user?.name ?? 'Usuário CONVIVA',
                      style: ConvivaTypography.titleSerifMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? '',
                      style: const TextStyle(
                        fontSize: 15,
                        color: ConvivaColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: ConvivaColors.pineGreenLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _getRoleName(user?.role),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: ConvivaColors.pineGreenText,
                        ),
                      ),
                    ),
                    if (user?.profileUrl != null) ...[
                      const SizedBox(height: 14),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final uri = Uri.parse(user!.profileUrl!);
                          final launched = await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                          if (!launched && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Não foi possível abrir o perfil no Facebook.'),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.open_in_new_rounded, size: 18),
                        label: const Text('Ver Perfil no Facebook'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(220, 42),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // SELETOR RÁPIDO DE PERFIL (para demonstração de hackathon)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: ConvivaColors.border, width: 1.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.swap_horiz_rounded,
                          color: ConvivaColors.pineGreen,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Alternar Perfil para Demonstração',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ConvivaColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Troque instantaneamente entre os 3 perfis do aplicativo:',
                      style: TextStyle(
                        fontSize: 13,
                        color: ConvivaColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _buildRoleButton(
                            context,
                            label: '👵 Idosa',
                            role: UserRole.senior,
                            isSelected: user?.role == UserRole.senior,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildRoleButton(
                            context,
                            label: '📋 Organizador',
                            role: UserRole.organizer,
                            isSelected: user?.role == UserRole.organizer,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildRoleButton(
                            context,
                            label: '🚗 Motorista',
                            role: UserRole.driver,
                            isSelected: user?.role == UserRole.driver,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Informações do Projeto
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: ConvivaColors.border, width: 1.2),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sobre o CONVIVA',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Plataforma inclusiva com acessibilidade para pessoas idosas, focada no combate à solidão, fomento a atividades comunitárias e facilitação de transporte solidário.',
                      style: TextStyle(
                        fontSize: 14,
                        color: ConvivaColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Botão Sair da Conta
              OutlinedButton.icon(
                onPressed: () {
                  state.logout();
                },
                icon: const Icon(
                  Icons.logout_rounded,
                  color: ConvivaColors.terracotta,
                ),
                label: const Text(
                  'Sair da Conta',
                  style: TextStyle(
                    color: ConvivaColors.terracotta,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRoleButton(
    BuildContext context, {
    required String label,
    required UserRole role,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        ConvivaState.instance.switchRole(role);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Alternado para o perfil: ${_getRoleName(role)}'),
            backgroundColor: ConvivaColors.pineGreen,
            duration: const Duration(seconds: 1),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color:
              isSelected ? ConvivaColors.pineGreen : ConvivaColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? ConvivaColors.pineGreen : ConvivaColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : ConvivaColors.textPrimary,
          ),
        ),
      ),
    );
  }

  String _getRoleName(UserRole? role) {
    switch (role) {
      case UserRole.senior:
        return 'Usuário / Idoso';
      case UserRole.organizer:
        return 'Organizador de Eventos';
      case UserRole.driver:
        return 'Motorista Parceiro Solidário';
      default:
        return 'Visitante';
    }
  }
}
