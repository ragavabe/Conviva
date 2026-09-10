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
        border: Border.all(color: ConvivaColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            offset: const Offset(0, 4),
            blurRadius: 12,
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
                // Topo do card: Título Serifado, Badge de Status e Menu de Ações
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        event.title,
                        style: ConvivaTypography.titleSerifMedium,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: event.statusBadgeBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        event.statusBadgeLabel,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: event.statusBadgeTextColor,
                        ),
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.more_vert,
                        size: 20,
                        color: ConvivaColors.textMuted,
                      ),
                      padding: EdgeInsets.zero,
                      onSelected: (val) {
                        if (val == 'edit') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CreateEventScreen(eventToEdit: event),
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
                                  style:
                                      TextStyle(color: ConvivaColors.terracotta)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Categoria e Distância em tags limpas
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: ConvivaColors.background,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: ConvivaColors.border),
                      ),
                      child: Text(
                        event.category,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: ConvivaColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '•  ${event.distance}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: ConvivaColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Data e Horário com ícone
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                      color: ConvivaColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        event.dateFormatted,
                        style: const TextStyle(
                          fontSize: 15,
                          color: ConvivaColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Local com ícone
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.place_outlined,
                      size: 19,
                      color: ConvivaColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        event.location,
                        style: const TextStyle(
                          fontSize: 15,
                          color: ConvivaColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Pequena descrição
                Text(
                  event.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: ConvivaColors.textSecondary,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 16),

                // Botão de Ação no Rodapé do Card com Seta Indicativa
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        event.actionCardText,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: event.actionCardTextColor,
                        ),
                      ),
                    ),
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
