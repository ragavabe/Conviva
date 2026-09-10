import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../core/typography.dart';
import '../../core/state.dart';

class SeniorTransportScreen extends StatelessWidget {
  const SeniorTransportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = ConvivaState.instance;

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final user = state.currentUser;
        final userRides = state.rides
            .where((r) => r.passengerId == (user?.id ?? 'user_marta'))
            .toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Transporte & Mobilidade'),
            automaticallyImplyLeading: false,
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Banner informativo
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: ConvivaColors.pineGreenLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: ConvivaColors.pineGreen.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.volunteer_activism_rounded,
                      color: ConvivaColors.pineGreen,
                      size: 36,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Carona Solidária CONVIVA',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ConvivaColors.pineGreenText,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Nossos motoristas voluntários cadastrados buscam você em casa e levam ao evento.',
                            style: TextStyle(
                              fontSize: 13,
                              color: ConvivaColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Suas Solicitações de Transporte',
                style: ConvivaTypography.titleSerifMedium,
              ),
              const SizedBox(height: 14),

              if (userRides.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: ConvivaColors.border),
                  ),
                  child: Column(
                    children: const [
                      Icon(
                        Icons.no_crash_rounded,
                        size: 48,
                        color: ConvivaColors.textMuted,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Nenhum transporte solicitado no momento.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Ao confirmar presença em um evento, clique em "Preciso de transporte" para ser buscado em sua casa.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: ConvivaColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...userRides.map(
                  (ride) => Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
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
                                ride.eventTitle,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'serif',
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: ride.statusColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                ride.statusLabel,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: ride.statusColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Ponto de partida: ${ride.pickupAddress}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: ConvivaColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Destino: ${ride.destinationAddress}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: ConvivaColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Horário previsto: ${ride.scheduledTime}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: ConvivaColors.pineGreen,
                          ),
                        ),
                        if (ride.driverName != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            'Motorista: ${ride.driverName}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: ConvivaColors.textPrimary,
                            ),
                          ),
                        ],
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
