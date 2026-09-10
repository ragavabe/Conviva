import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../core/typography.dart';
import '../../core/state.dart';
import 'event_details_screen.dart';

class SeniorMyEventsScreen extends StatelessWidget {
  const SeniorMyEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = ConvivaState.instance;

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final myEvents =
            state.events.where((e) => e.isUserParticipating).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Meus Eventos Confirmados'),
            automaticallyImplyLeading: false,
          ),
          body: myEvents.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.event_note_rounded,
                          size: 64,
                          color: ConvivaColors.border,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Você ainda não confirmou presença em nenhum evento.',
                          textAlign: TextAlign.center,
                          style: ConvivaTypography.titleSerifSmall,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Explore os encontros na tela inicial e participe!',
                          textAlign: TextAlign.center,
                          style: ConvivaTypography.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: myEvents.length,
                  itemBuilder: (ctx, idx) {
                    final event = myEvents[idx];
                    final ride = state.getRideForEvent(event.id);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 18),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: ConvivaColors.border,
                          width: 1.2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  event.title,
                                  style: ConvivaTypography.titleSerifSmall,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: ConvivaColors.pineGreenLight,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Inscrito',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: ConvivaColors.pineGreenText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 16,
                                color: ConvivaColors.textSecondary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                event.dateFormatted,
                                style: const TextStyle(
                                  color: ConvivaColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.place_outlined,
                                size: 17,
                                color: ConvivaColors.textSecondary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  event.location,
                                  style: const TextStyle(
                                    color: ConvivaColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EventDetailsScreen(
                                          eventId: event.id,
                                        ),
                                      ),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size(0, 44),
                                  ),
                                  child: const Text(
                                    'Ver detalhes',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    if (ride == null) {
                                      state.requestRide(
                                        eventId: event.id,
                                        eventTitle: event.title,
                                        destinationAddress: event.location,
                                        pickupAddress:
                                            state.currentUser?.address ??
                                            'Rua das Camélias, 120',
                                        scheduledTime: '13:30',
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Transporte solicitado para este evento!',
                                          ),
                                          backgroundColor:
                                              ConvivaColors.pineGreen,
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Status da carona: ${ride.statusLabel}',
                                          ),
                                          backgroundColor:
                                              ConvivaColors.pineGreen,
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.directions_car_filled_rounded,
                                    size: 18,
                                  ),
                                  label: Text(
                                    ride == null
                                        ? 'Preciso de carona'
                                        : 'Carona Ativa',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(0, 44),
                                    backgroundColor: ride == null
                                        ? ConvivaColors.pineGreen
                                        : ConvivaColors.ochre,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
