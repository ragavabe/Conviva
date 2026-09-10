import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../core/typography.dart';
import '../../core/state.dart';
import '../../models/event.dart';
import '../../models/ride.dart';

class EventDetailsScreen extends StatefulWidget {
  final String eventId;

  const EventDetailsScreen({super.key, required this.eventId});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
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
                // BANNER SUPERIOR COM COR DINÂMICA
                Container(
                  color: event.headerColor,
                  padding: const EdgeInsets.fromLTRB(20, 48, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Botão Voltar Circular
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.22),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
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

                // CORPO DO EVENTO (Fundo Creme)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildInfoRow(
                        icon: Icons.calendar_today_outlined,
                        text: event.dateFormatted,
                      ),
                      const SizedBox(height: 14),
                      _buildInfoRow(
                        icon: Icons.place_outlined,
                        text: event.location,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 18),
                        child: Divider(
                          color: ConvivaColors.divider,
                          thickness: 1,
                        ),
                      ),
                      Text(
                        event.description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: ConvivaColors.textPrimary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // BOTÕES DE AÇÃO POR STATUS
                      if (event.status == EventStatus.upcoming) ...[
                        if (!event.isUserParticipating) ...[
                          ElevatedButton(
                            onPressed: () {
                              state.toggleEventParticipation(event.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Presença confirmada no "${event.title}"!',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  backgroundColor: ConvivaColors.pineGreen,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ConvivaColors.pineGreen,
                            ),
                            child: const Text('Confirmar presença'),
                          ),
                        ] else ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: ConvivaColors.pineGreenLight,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: ConvivaColors.pineGreen),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: ConvivaColors.pineGreen,
                                  size: 24,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Você está participando!',
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
                          TextButton(
                            onPressed: () {
                              state.toggleEventParticipation(event.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Participação cancelada.'),
                                ),
                              );
                            },
                            child: const Text(
                              'Cancelar participação',
                              style: TextStyle(
                                color: ConvivaColors.terracotta,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],

                      if (event.status == EventStatus.full) ...[
                        OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Você foi adicionado à lista de espera com sucesso!',
                                  style: TextStyle(fontSize: 16),
                                ),
                                backgroundColor: ConvivaColors.terracotta,
                              ),
                            );
                          },
                          child: const Text('Entrar na lista de espera'),
                        ),
                      ],

                      if (event.status == EventStatus.completed) ...[
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: ConvivaColors.ochreLight,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: ConvivaColors.ochre.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Este evento já aconteceu.',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: ConvivaColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Você esteve presente?',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: ConvivaColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        state.confirmPastAttendance(
                                          event.id,
                                          false,
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Obrigado pelo feedback!'),
                                          ),
                                        );
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                      ),
                                      child: const Text('Não estive'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        state.confirmPastAttendance(
                                          event.id,
                                          true,
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Presença confirmada! Que ótimo ter você por lá.',
                                            ),
                                            backgroundColor: ConvivaColors.pineGreen,
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ConvivaColors.pineGreen,
                                      ),
                                      child: const Text('Sim, estive lá'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 32),

                      // SEÇÃO DE PARTICIPANTES
                      Text(
                        event.status == EventStatus.completed
                            ? 'Quem esteve presente (${event.confirmedCount})'
                            : (event.status == EventStatus.full
                                  ? 'Participantes confirmados (${event.confirmedCount})'
                                  : 'Quem já confirmou (${event.confirmedCount})'),
                        style: ConvivaTypography.titleSerifMedium,
                      ),
                      const SizedBox(height: 16),

                      ...event.participants.map(
                        (p) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildParticipantTile(event.id, p),
                        ),
                      ),

                      // Opção de Carona
                      if (event.status == EventStatus.upcoming &&
                          event.isUserParticipating) ...[
                        const SizedBox(height: 24),
                        _buildTransportPromptCard(event),
                      ],
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

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFEFE8D8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: ConvivaColors.textPrimary, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: ConvivaColors.textPrimary,
            ),
          ),
        ),
      ],
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
                color: participant.isFriend
                    ? ConvivaColors.pineGreenLight
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: participant.isFriend
                      ? ConvivaColors.pineGreen
                      : ConvivaColors.border,
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
                    participant.isFriend ? 'Adicionado' : 'Adicionar',
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
            'Você gostaria de ser buscado em casa para este evento?',
            style: TextStyle(fontSize: 14, color: ConvivaColors.textSecondary),
          ),
          const SizedBox(height: 14),
          if (existingRide == null) ...[
            ElevatedButton.icon(
              onPressed: () {
                _showRequestRideDialog(context, event);
              },
              icon: const Icon(Icons.hail_rounded),
              label: const Text('Preciso de transporte'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ConvivaColors.pineGreen,
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ConvivaColors.pineGreenLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: ConvivaColors.pineGreen,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Status: ${existingRide.statusLabel}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ConvivaColors.pineGreenText,
                      ),
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

  void _showRequestRideDialog(BuildContext context, ConvivaEvent event) {
    final state = ConvivaState.instance;
    final user = state.currentUser;
    final addressCtrl = TextEditingController(
      text: user?.address ?? 'Rua das Camélias, 120 - Jardim das Flores',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Solicitar Carona Solidária',
          style: ConvivaTypography.titleSerifMedium,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Um motorista voluntário do CONVIVA buscará você no endereço abaixo:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: addressCtrl,
              decoration: const InputDecoration(
                labelText: 'Endereço de partida',
                prefixIcon: Icon(Icons.home_outlined),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Destino: ${event.location}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: ConvivaColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              state.requestRide(
                eventId: event.id,
                eventTitle: event.title,
                destinationAddress: event.location,
                pickupAddress: addressCtrl.text.trim(),
                scheduledTime: '13:30',
              );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Transporte solicitado! Os motoristas parceiros já receberam sua solicitação.',
                  ),
                  backgroundColor: ConvivaColors.pineGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ConvivaColors.pineGreen,
              minimumSize: const Size(120, 48),
            ),
            child: const Text('Confirmar Solicitação'),
          ),
        ],
      ),
    );
  }
}
