import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../core/typography.dart';
import '../../core/state.dart';
import '../../models/event.dart';
import 'create_event_screen.dart';
import 'attendance_list_screen.dart';

class OrganizerDashboardScreen extends StatelessWidget {
  const OrganizerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = ConvivaState.instance;

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final events = state.events;
        final upcomingCount = events
            .where((e) => e.status == EventStatus.upcoming)
            .length;
        final totalParticipants = events.fold<int>(
          0,
          (sum, e) => sum + e.confirmedCount,
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Dashboard do Organizador'),
            automaticallyImplyLeading: false,
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Visão Geral das Atividades',
                style: ConvivaTypography.titleSerifMedium,
              ),
              const SizedBox(height: 16),

              // Cards de Métricas
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      title: 'Total de Eventos',
                      value: '${events.length}',
                      icon: Icons.event,
                      color: ConvivaColors.pineGreen,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard(
                      title: 'Próximos',
                      value: '$upcomingCount',
                      icon: Icons.upcoming,
                      color: ConvivaColors.terracotta,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildMetricCard(
                title: 'Total de Idosos Participantes Confirmados',
                value: '$totalParticipants',
                icon: Icons.group_rounded,
                color: ConvivaColors.ochreDark,
                isWide: true,
              ),
              const SizedBox(height: 24),

              // Botão Criar Evento em Destaque
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreateEventScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add_rounded, size: 24),
                label: const Text('+ Criar Novo Evento'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ConvivaColors.pineGreen,
                  minimumSize: const Size(double.infinity, 56),
                ),
              ),
              const SizedBox(height: 28),

              const Text(
                'Eventos Ativos Recentes',
                style: ConvivaTypography.titleSerifMedium,
              ),
              const SizedBox(height: 12),
              ...events
                  .take(3)
                  .map(
                    (event) => Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        title: Text(
                          event.title,
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        subtitle: Text(
                          '${event.dateFormatted}\n${event.confirmedCount} idosos confirmados',
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  AttendanceListScreen(event: event),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    bool isWide = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ConvivaColors.border, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: ConvivaColors.textSecondary,
                ),
              ),
              Icon(icon, color: color, size: 24),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: isWide ? 34 : 28,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'serif',
            ),
          ),
        ],
      ),
    );
  }
}
