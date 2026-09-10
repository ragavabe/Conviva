import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../core/typography.dart';
import '../../core/state.dart';
import '../../models/event.dart';

class AttendanceListScreen extends StatefulWidget {
  final ConvivaEvent event;

  const AttendanceListScreen({super.key, required this.event});

  @override
  State<AttendanceListScreen> createState() => _AttendanceListScreenState();
}

class _AttendanceListScreenState extends State<AttendanceListScreen> {
  void _exportList() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Lista de Presença Exportada',
              style: ConvivaTypography.titleSerifMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Arquivo pronto para download / compartilhamento:\n"lista_presenca_${widget.event.id}.csv"',
              style: const TextStyle(
                color: ConvivaColors.textSecondary,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: ConvivaColors.background,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                'Evento: ${widget.event.title}\nTotal de inscritos: ${widget.event.participants.length}\nPresentes marcados: ${widget.event.participants.where((p) => p.isPresent).length}',
                style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Lista exportada e salva com sucesso no dispositivo!',
                    ),
                    backgroundColor: ConvivaColors.pineGreen,
                  ),
                );
              },
              icon: const Icon(Icons.share_rounded),
              label: const Text('Compartilhar / Baixar CSV'),
            ),
          ],
        ),
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
          (e) => e.id == widget.event.id,
          orElse: () => widget.event,
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Lista de Presença'),
            actions: [
              IconButton(
                icon: const Icon(Icons.file_download_outlined),
                tooltip: 'Exportar Lista',
                onPressed: _exportList,
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(event.title, style: ConvivaTypography.titleSerifLarge),
              const SizedBox(height: 4),
              Text(
                '${event.dateFormatted} • ${event.location}',
                style: const TextStyle(
                  fontSize: 15,
                  color: ConvivaColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Inscritos (${event.participants.length})',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: ConvivaColors.textPrimary,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: _exportList,
                    icon: const Icon(Icons.download_rounded, size: 18),
                    label: const Text(
                      'Exportar',
                      style: TextStyle(fontSize: 14),
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(110, 38),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...event.participants.map(
                (p) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: ConvivaColors.border),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: ConvivaColors.avatarBg,
                        child: Text(
                          p.initials,
                          style: const TextStyle(
                            fontFamily: 'serif',
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
                              p.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (p.phone != null)
                              Text(
                                p.phone!,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: ConvivaColors.textSecondary,
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Checkbox interativo de Presença
                      InkWell(
                        onTap: () {
                          state.togglePresenceInAttendanceList(
                            event.id,
                            p.id,
                            !p.isPresent,
                          );
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: p.isPresent
                                ? ConvivaColors.pineGreenLight
                                : ConvivaColors.background,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: p.isPresent
                                  ? ConvivaColors.pineGreen
                                  : ConvivaColors.border,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                p.isPresent
                                    ? Icons.check_circle_rounded
                                    : Icons.radio_button_unchecked_rounded,
                                size: 18,
                                color: p.isPresent
                                    ? ConvivaColors.pineGreen
                                    : ConvivaColors.textMuted,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                p.isPresent ? 'Presente' : 'Ausente',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: p.isPresent
                                      ? ConvivaColors.pineGreenText
                                      : ConvivaColors.textSecondary,
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
            ],
          ),
        );
      },
    );
  }
}
