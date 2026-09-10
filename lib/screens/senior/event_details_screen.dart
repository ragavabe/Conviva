import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../core/typography.dart';
import '../../core/state.dart';
import '../../models/event.dart';

class EventDetailsScreen extends StatefulWidget {
  final String eventId;

  const EventDetailsScreen({super.key, required this.eventId});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  void _showCelebrationDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: ConvivaColors.pineGreenLight,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('🎉', style: TextStyle(fontSize: 42)),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Presença Confirmada!',
              style: ConvivaTypography.titleSerifMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Parabéns por participar!\nSua vaga está garantida no:\n"$title".\n\nNossos amigos já estão ansiosos pela sua chegada!',
              style: const TextStyle(
                fontSize: 16,
                color: ConvivaColors.textPrimary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: ConvivaColors.pineGreen,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Excelente! ✨', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  void _showShareWhatsAppDialog(BuildContext context, ConvivaEvent event) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: const [
            Icon(Icons.chat_bubble_rounded, color: Color(0xFF25D366), size: 28),
            SizedBox(width: 10),
            Text('Convidar no WhatsApp', style: ConvivaTypography.titleSerifSmall),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Envie um convite carinhoso para seus amigos da família, da igreja ou do bairro:',
              style: TextStyle(fontSize: 15, color: ConvivaColors.textPrimary),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFBBF7D0)),
              ),
              child: Text(
                'Olá! Gostaria de te convidar para ir comigo no "${event.title}", dia ${event.dateFormatted}, no local ${event.location}. Vai ser uma tarde maravilhosa no Conviva! Vamos?',
                style: const TextStyle(fontSize: 14, color: Color(0xFF166534), height: 1.3),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Convite preparado para envio via WhatsApp! 📲'),
                  backgroundColor: Color(0xFF25D366),
                ),
              );
            },
            icon: const Icon(Icons.send_rounded, size: 18),
            label: const Text('Enviar Convite'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ConvivaState.instance;

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final event = state.events.firstWhere(
          (e) => e.id == widget.eventId,
          orElse: () => state.events.first,
        );

        return Scaffold(
          backgroundColor: ConvivaColors.background,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // BANNER SUPERIOR VIBRANTE COM CATEGORIA E ÁUDIO
                Container(
                  color: event.headerColor,
                  padding: const EdgeInsets.fromLTRB(20, 48, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Linha de navegação superior (Voltar + Áudio + Categoria)
                      Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            borderRadius: BorderRadius.circular(24),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.22),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Voltar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          // Botão de Leitura em Voz Alta
                          IconButton(
                            onPressed: () {
                              state.speak(
                                'Detalhes de ${event.title}. Dia ${event.dateFormatted}, no local ${event.location}. ${event.description}',
                              );
                            },
                            tooltip: 'Ouvir detalhes deste evento',
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.22),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.volume_up_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Tag de categoria
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          event.category.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontFamily: 'serif',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),

                // CORPO DO EVENTO
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Data e Horário com destaque
                      _buildInfoTile(
                        icon: Icons.calendar_month_rounded,
                        title: 'Quando acontece',
                        subtitle: event.dateFormatted,
                        badgeText: event.distance,
                      ),
                      const SizedBox(height: 12),

                      // Localização
                      _buildInfoTile(
                        icon: Icons.place_rounded,
                        title: 'Onde será',
                        subtitle: event.location,
                        iconColor: ConvivaColors.terracotta,
                      ),
                      const SizedBox(height: 20),

                      // COMODIDADES & ACESSIBILIDADE PARA IDOSOS
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: ConvivaColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Acessibilidade e Conforto no Local',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ConvivaColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: const [
                                _AmenityBadge(icon: '♿', label: 'Rampa de Acesso'),
                                _AmenityBadge(icon: '🪑', label: 'Assentos Confortáveis'),
                                _AmenityBadge(icon: '☕', label: 'Café & Lanche Grátis'),
                                _AmenityBadge(icon: '🚗', label: 'Carona Solidária'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // DESCRIÇÃO
                      const Text(
                        'Sobre esta atividade',
                        style: ConvivaTypography.titleSerifSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: ConvivaColors.textPrimary,
                          height: 1.55,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // BOTÕES PRINCIPAIS DE AÇÃO
                      if (event.status == EventStatus.upcoming) ...[
                        if (!event.isUserParticipating) ...[
                          ElevatedButton.icon(
                            onPressed: () {
                              state.toggleEventParticipation(event.id);
                              _showCelebrationDialog(context, event.title);
                            },
                            icon: const Icon(Icons.thumb_up_alt_rounded, size: 20),
                            label: const Text(
                              'Confirmar Minha Presença (Grátis)',
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ConvivaColors.pineGreen,
                              minimumSize: const Size(double.infinity, 54),
                            ),
                          ),
                        ] else ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                            decoration: BoxDecoration(
                              color: ConvivaColors.pineGreenLight,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: ConvivaColors.pineGreen, width: 1.5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: ConvivaColors.pineGreen,
                                  size: 26,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Sua presença está confirmada! 🎉',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: ConvivaColors.pineGreenText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                state.toggleEventParticipation(event.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Participação cancelada.')),
                                );
                              },
                              child: const Text(
                                'Cancelar minha presença',
                                style: TextStyle(
                                  color: ConvivaColors.terracotta,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],

                      const SizedBox(height: 12),

                      // BOTÃO CONVIDAR AMIGOS NO WHATSAPP
                      OutlinedButton.icon(
                        onPressed: () => _showShareWhatsAppDialog(context, event),
                        icon: const Icon(Icons.chat_bubble_outline_rounded,
                            size: 20, color: Color(0xFF25D366)),
                        label: const Text(
                          'Convidar Amigos no WhatsApp 📲',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          side: const BorderSide(color: Color(0xFF25D366), width: 1.5),
                          backgroundColor: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // CARD DE CARONA SOLIDÁRIA
                      _buildTransportPromptCard(event),

                      const SizedBox(height: 28),

                      // SEÇÃO DE PARTICIPANTES (QUEM JÁ CONFIRMOU)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Quem já confirmou (${event.confirmedCount})',
                            style: ConvivaTypography.titleSerifSmall,
                          ),
                          const Text('👥 Amigos do Conviva',
                              style: TextStyle(fontSize: 13, color: ConvivaColors.textSecondary)),
                        ],
                      ),
                      const SizedBox(height: 14),

                      ...event.participants.map(
                        (p) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildParticipantTile(event.id, p),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Color iconColor = ConvivaColors.pineGreen,
    String? badgeText,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ConvivaColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: ConvivaColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ConvivaColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          if (badgeText != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: ConvivaColors.pineGreenLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                badgeText,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: ConvivaColors.pineGreenText,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildParticipantTile(String eventId, participant) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ConvivaColors.border, width: 1.1),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: ConvivaColors.avatarBg,
            child: Text(
              participant.initials,
              style: const TextStyle(
                fontFamily: 'serif',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ConvivaColors.pineGreenText,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  participant.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ConvivaColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  participant.timeAgo,
                  style: const TextStyle(
                    fontSize: 13,
                    color: ConvivaColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              ConvivaState.instance.toggleParticipantFriend(
                eventId,
                participant.id,
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: participant.isFriend ? ConvivaColors.pineGreenLight : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: participant.isFriend ? ConvivaColors.pineGreen : ConvivaColors.border,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    participant.isFriend ? Icons.check : Icons.person_add_alt_1,
                    size: 16,
                    color: participant.isFriend
                        ? ConvivaColors.pineGreenText
                        : ConvivaColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    participant.isFriend ? 'Amigo(a) ✓' : 'Adicionar',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: participant.isFriend
                          ? ConvivaColors.pineGreenText
                          : ConvivaColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransportPromptCard(ConvivaEvent event) {
    final state = ConvivaState.instance;
    final existingRide = state.getRideForEvent(event.id);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
                Icons.directions_car_filled_rounded,
                color: ConvivaColors.pineGreen,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'Mobilidade & Carona Solidária',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ConvivaColors.pineGreenText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Você gostaria de ser buscado em casa para este evento com segurança?',
            style: TextStyle(fontSize: 14, color: ConvivaColors.textSecondary),
          ),
          const SizedBox(height: 14),
          if (existingRide == null) ...[
            ElevatedButton.icon(
              onPressed: () {
                state.requestRide(
                  eventId: event.id,
                  eventTitle: event.title,
                  destinationAddress: event.location,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Carona solicitada com sucesso! 🚗'),
                    backgroundColor: ConvivaColors.pineGreen,
                  ),
                );
              },
              icon: const Icon(Icons.hail_rounded, size: 18),
              label: const Text('Solicitar Carona Grátis 🚗'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ConvivaColors.pineGreen,
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ConvivaColors.pineGreenLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: ConvivaColors.pineGreen),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Carona solicitada (${existingRide.statusLabel})',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AmenityBadge extends StatelessWidget {
  final String icon;
  final String label;

  const _AmenityBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: ConvivaColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ConvivaColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: ConvivaColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
