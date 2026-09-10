import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../core/typography.dart';
import '../core/state.dart';
import '../models/event.dart';
import '../screens/organizer/create_event_screen.dart';

class EventCard extends StatelessWidget {
  final ConvivaEvent event;
  final VoidCallback onTap;

  const EventCard({super.key, required this.event, required this.onTap});

  IconData _getCategoryIcon(String category) {
    final cat = category.toLowerCase();
    if (cat.contains('artesanato') || cat.contains('oficina')) {
      return Icons.palette_rounded;
    }
    if (cat.contains('bingo') || cat.contains('jogo') || cat.contains('lazer')) {
      return Icons.casino_rounded;
    }
    if (cat.contains('caminhada') || cat.contains('saúde') || cat.contains('parque')) {
      return Icons.directions_walk_rounded;
    }
    if (cat.contains('música') || cat.contains('dança') || cat.contains('seresta')) {
      return Icons.music_note_rounded;
    }
    if (cat.contains('café') || cat.contains('culinária')) {
      return Icons.coffee_rounded;
    }
    return Icons.event_available_rounded;
  }

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
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: ConvivaColors.pineGreenLight,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('🎉', style: TextStyle(fontSize: 40)),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Que Maravilha!',
              style: ConvivaTypography.titleSerifMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Sua presença está confirmada no evento:\n"$title".\n\nNossos amigos já estão ansiosos para te ver!',
              style: const TextStyle(
                fontSize: 16,
                color: ConvivaColors.textPrimary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: ConvivaColors.pineGreen,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Entendi, obrigado! ✨', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  void _showRideRequestDialog(BuildContext context) {
    final state = ConvivaState.instance;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: const [
            Icon(Icons.directions_car_filled_rounded, color: ConvivaColors.pineGreen, size: 28),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Pedir Carona Solidária',
                style: ConvivaTypography.titleSerifSmall,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Você gostaria que um de nossos motoristas voluntários te busque em casa para o "${event.title}"?',
              style: const TextStyle(fontSize: 15, color: ConvivaColors.textPrimary),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ConvivaColors.pineGreenLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: ConvivaColors.pineGreen.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: const [
                  CircleAvatar(
                    backgroundColor: ConvivaColors.pineGreen,
                    child: Icon(Icons.verified_user_rounded, color: Colors.white, size: 20),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Motorista Roberto Silva',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Text(
                          'Carro seguro · 4.9 ⭐ (52 viagens)',
                          style: TextStyle(fontSize: 12, color: ConvivaColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Agora não', style: TextStyle(fontSize: 15)),
          ),
          ElevatedButton(
            onPressed: () {
              state.requestRide(
                eventId: event.id,
                eventTitle: event.title,
                destinationAddress: event.location,
              );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Carona solicitada com sucesso! O motorista entrará em contato. 🚗',
                    style: TextStyle(fontSize: 15),
                  ),
                  backgroundColor: ConvivaColors.pineGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ConvivaColors.pineGreen,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: const Text('Solicitar Carona 🚗', style: TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir evento?'),
        content: Text('Deseja realmente excluir "${event.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final state = ConvivaState.instance;
              state.deleteEvent(event.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Evento "${event.title}" excluído.'),
                  backgroundColor: ConvivaColors.textPrimary,
                  action: SnackBarAction(
                    label: 'Desfazer',
                    textColor: Colors.amber,
                    onPressed: () {
                      state.undoDeleteEvent();
                    },
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ConvivaColors.terracotta,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ConvivaState.instance;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: event.isUserParticipating
              ? ConvivaColors.pineGreen.withValues(alpha: 0.6)
              : ConvivaColors.border,
          width: event.isUserParticipating ? 2.0 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 6),
            blurRadius: 16,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Linha superior: Categoria com ícone colorido + Status Tag + Menu
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: ConvivaColors.pineGreenLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getCategoryIcon(event.category),
                            size: 16,
                            color: ConvivaColors.pineGreen,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            event.category,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: ConvivaColors.pineGreenText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: event.statusBadgeBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        event.statusBadgeLabel,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: event.statusBadgeTextColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Botão de Áudio Rápido (Ler em voz alta)
                    IconButton(
                      icon: const Icon(
                        Icons.volume_up_rounded,
                        color: ConvivaColors.pineGreen,
                        size: 24,
                      ),
                      tooltip: 'Ouvir informações do evento',
                      onPressed: () {
                        state.speak(
                          '${event.title}. Data: ${event.dateFormatted}. Local: ${event.location}. ${event.description}',
                        );
                      },
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        size: 22,
                        color: ConvivaColors.textSecondary,
                      ),
                      padding: EdgeInsets.zero,
                      onSelected: (val) {
                        if (val == 'edit') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CreateEventScreen(eventToEdit: event),
                            ),
                          );
                        } else if (val == 'duplicate') {
                          state.duplicateEvent(event.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Evento duplicado com sucesso!'),
                              backgroundColor: ConvivaColors.pineGreen,
                            ),
                          );
                        } else if (val == 'delete') {
                          _showDeleteDialog(context);
                        }
                      },
                      itemBuilder: (ctx) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit_outlined, size: 18),
                              SizedBox(width: 8),
                              Text('Editar'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'duplicate',
                          child: Row(
                            children: [
                              Icon(Icons.copy_outlined, size: 18),
                              SizedBox(width: 8),
                              Text('Duplicar'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline,
                                  size: 18, color: ConvivaColors.terracotta),
                              SizedBox(width: 8),
                              Text('Excluir',
                                  style: TextStyle(color: ConvivaColors.terracotta)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Título do evento em destaque
                Text(
                  event.title,
                  style: ConvivaTypography.titleSerifMedium.copyWith(
                    fontSize: 21,
                    height: 1.25,
                    color: ConvivaColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),

                // Data e Horário em linha destacada com ícone
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: ConvivaColors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_rounded,
                        size: 20,
                        color: ConvivaColors.pineGreen,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          event.dateFormatted,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: ConvivaColors.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        event.distance,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: ConvivaColors.pineGreenText,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Localização
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.place_rounded,
                      size: 20,
                      color: ConvivaColors.terracotta,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        event.location,
                        style: const TextStyle(
                          fontSize: 14,
                          color: ConvivaColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Descrição amigável
                Text(
                  event.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: ConvivaColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),

                // Indicador Social (Amigos que vão)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F7F1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.group_rounded,
                        size: 18,
                        color: ConvivaColors.pineGreen,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${event.attendeesCount} participantes confirmados',
                          style: const TextStyle(
                            fontSize: 13,
                            color: ConvivaColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // LINHA DE AÇÕES TÁTEIS E REASSURADORAS
                Row(
                  children: [
                    // Botão Quero Ir / Confirmar Presença
                    if (event.status == EventStatus.upcoming) ...[
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final willParticipate = !event.isUserParticipating;
                            state.toggleEventParticipation(event.id);
                            if (willParticipate) {
                              _showCelebrationDialog(context, event.title);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Participação cancelada.'),
                                ),
                              );
                            }
                          },
                          icon: Icon(
                            event.isUserParticipating
                                ? Icons.check_circle_rounded
                                : Icons.thumb_up_alt_rounded,
                            size: 18,
                          ),
                          label: Text(
                            event.isUserParticipating
                                ? 'Vou participar! ✓'
                                : 'Quero Ir! 🙋‍♀️',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: event.isUserParticipating
                                ? ConvivaColors.pineGreenLight
                                : ConvivaColors.pineGreen,
                            foregroundColor: event.isUserParticipating
                                ? ConvivaColors.pineGreenText
                                : Colors.white,
                            minimumSize: const Size(0, 48),
                            side: event.isUserParticipating
                                ? const BorderSide(color: ConvivaColors.pineGreen)
                                : BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Botão de Carona Solidária se estiver participando
                      OutlinedButton(
                        onPressed: () => _showRideRequestDialog(context),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(48, 48),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: ConvivaColors.pineGreen),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.directions_car_filled_rounded,
                                size: 18, color: ConvivaColors.pineGreen),
                            SizedBox(width: 4),
                            Text('Carona', style: TextStyle(fontSize: 13, color: ConvivaColors.pineGreen)),
                          ],
                        ),
                      ),
                    ] else if (event.status == EventStatus.full) ...[
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Você está na lista de espera deste evento!'),
                                backgroundColor: ConvivaColors.terracotta,
                              ),
                            );
                          },
                          icon: const Icon(Icons.hourglass_empty_rounded, size: 18),
                          label: const Text('Lista de Espera 📋', style: TextStyle(fontSize: 14)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: ConvivaColors.terracotta,
                            side: const BorderSide(color: ConvivaColors.terracotta),
                            minimumSize: const Size(0, 46),
                          ),
                        ),
                      ),
                    ] else ...[
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onTap,
                          icon: const Icon(Icons.star_rounded, size: 18, color: ConvivaColors.ochre),
                          label: const Text('Ver como foi ✨', style: TextStyle(fontSize: 14)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: ConvivaColors.ochreDark,
                            side: const BorderSide(color: ConvivaColors.ochre),
                            minimumSize: const Size(0, 46),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
