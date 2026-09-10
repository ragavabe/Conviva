import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../core/typography.dart';
import '../../core/state.dart';
import '../../models/ride.dart';
import 'driver_route_screen.dart';

class DriverRidesScreen extends StatelessWidget {
  const DriverRidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = ConvivaState.instance;

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final user = state.currentUser;
        final rides = state.rides;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Corridas e Mobilidade'),
            automaticallyImplyLeading: false,
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Solicitações de Transporte',
                style: ConvivaTypography.titleSerifMedium,
              ),
              const SizedBox(height: 6),
              const Text(
                'Ajude idosos a chegarem com segurança aos eventos comunitários.',
                style: ConvivaTypography.bodyMedium,
              ),
              const SizedBox(height: 18),
              ...rides.map(
                (ride) => Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: ConvivaColors.border, width: 1.2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: ConvivaColors.avatarBg,
                                child: const Icon(
                                  Icons.person,
                                  size: 20,
                                  color: ConvivaColors.pineGreen,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                ride.passengerName,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: ride.statusColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
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
                      const SizedBox(height: 14),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.my_location_rounded,
                            size: 18,
                            color: ConvivaColors.pineGreen,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Partida: ${ride.pickupAddress}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: ConvivaColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            size: 18,
                            color: ConvivaColors.terracotta,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Destino: ${ride.destinationAddress}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: ConvivaColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            size: 18,
                            color: ConvivaColors.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Horário de busca: ${ride.scheduledTime}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: ConvivaColors.pineGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          if (ride.status == RideStatus.requested) ...[
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  state.acceptRide(
                                    ride.id,
                                    user?.name ?? 'Roberto Santos',
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Corrida aceita! O passageiro foi notificado.',
                                      ),
                                      backgroundColor: ConvivaColors.pineGreen,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ConvivaColors.pineGreen,
                                  minimumSize: const Size(0, 44),
                                ),
                                child: const Text('Aceitar corrida'),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        DriverRouteScreen(ride: ride),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.map_outlined, size: 18),
                              label: const Text('Ver rota'),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(0, 44),
                              ),
                            ),
                          ),
                        ],
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
