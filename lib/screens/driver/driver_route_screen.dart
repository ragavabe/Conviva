import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../core/typography.dart';
import '../../core/state.dart';
import '../../models/ride.dart';

class DriverRouteScreen extends StatelessWidget {
  final RideRequest? ride;

  const DriverRouteScreen({super.key, this.ride});

  @override
  Widget build(BuildContext context) {
    final state = ConvivaState.instance;

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final activeRide =
            ride ??
            (state.rides.isNotEmpty
                ? state.rides.first
                : RideRequest(
                    id: 'demo',
                    eventId: 'ev_1',
                    eventTitle: 'Bazar de Artesanato',
                    passengerId: 'p1',
                    passengerName: 'Dona Marta',
                    passengerPhone: '(11) 98765-4321',
                    pickupAddress: 'Rua das Camélias, 120 - Jardim das Flores',
                    destinationAddress: 'Centro Comunitário Jardim das Flores',
                    scheduledTime: '13:30',
                  ));

        return Scaffold(
          appBar: AppBar(
            title: const Text('Navegação & Rota'),
            actions: [
              IconButton(
                icon: const Icon(Icons.open_in_new_rounded),
                tooltip: 'Abrir no Google Maps / Waze',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Abrindo rota no aplicativo de GPS externo...',
                      ),
                      backgroundColor: ConvivaColors.pineGreen,
                    ),
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              // MAPA VETORIAL SIMULADO COM DESIGN CUSTOMIZADO
              Expanded(
                flex: 5,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9F0E8),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: ConvivaColors.border, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      children: [
                        // Grid e Traçado da Rota Simulado
                        CustomPaint(
                          size: Size.infinite,
                          painter: RouteMapPainter(),
                        ),

                        // Ponto A - Embarque do Passageiro (Idoso)
                        Positioned(
                          left: 45,
                          top: 60,
                          child: _buildMapPin(
                            label: '1. Buscar Passageiro',
                            address: activeRide.pickupAddress,
                            color: ConvivaColors.pineGreen,
                            icon: Icons.person_pin_circle_rounded,
                          ),
                        ),

                        // Ponto B - Destino do Evento
                        Positioned(
                          right: 30,
                          bottom: 70,
                          child: _buildMapPin(
                            label: '2. Local do Evento',
                            address: activeRide.destinationAddress,
                            color: ConvivaColors.terracotta,
                            icon: Icons.flag_rounded,
                          ),
                        ),

                        // Badge de Distância e Tempo Estimado
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.navigation_rounded,
                                  size: 18,
                                  color: ConvivaColors.pineGreen,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  '4,2 km • 12 min',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
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
              ),

              // INFORMAÇÕES DO PASSAGEIRO E AÇÕES DA CORRIDA
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                    border: Border(
                      top: BorderSide(color: ConvivaColors.border),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Passageiro: ${activeRide.passengerName}',
                            style: ConvivaTypography.titleSerifSmall,
                          ),
                          IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Ligando para ${activeRide.passengerPhone}...',
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.phone_in_talk_rounded,
                              color: ConvivaColors.pineGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Evento: ${activeRide.eventTitle}',
                        style: const TextStyle(
                          color: ConvivaColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          state.updateRideStatus(
                            activeRide.id,
                            RideStatus.inProgress,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Trajeto iniciado! Dirija com cuidado.',
                              ),
                              backgroundColor: ConvivaColors.pineGreen,
                            ),
                          );
                        },
                        icon: const Icon(Icons.navigation_rounded),
                        label: const Text('Iniciar Navegação'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ConvivaColors.pineGreen,
                        ),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: () {
                          state.updateRideStatus(
                            activeRide.id,
                            RideStatus.completed,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Corrida finalizada! Obrigado pelo voluntariado.',
                              ),
                              backgroundColor: ConvivaColors.pineGreen,
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.check_circle_outline_rounded,
                          color: ConvivaColors.pineGreen,
                        ),
                        label: const Text('Concluir Corrida'),
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

  Widget _buildMapPin({
    required String label,
    required String address,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              SizedBox(
                width: 140,
                child: Text(
                  address,
                  style: const TextStyle(
                    fontSize: 11,
                    color: ConvivaColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Pintura customizada de ruas e rota visual para o mapa do motorista
class RouteMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadBorderPaint = Paint()
      ..color = const Color(0xFFD4DEC4)
      ..strokeWidth = 18
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final roadPath = Path();
    roadPath.moveTo(60, 40);
    roadPath.lineTo(100, 160);
    roadPath.lineTo(size.width * 0.45, 180);
    roadPath.lineTo(size.width * 0.65, size.height * 0.55);
    roadPath.lineTo(size.width - 70, size.height - 80);

    canvas.drawPath(roadPath, roadBorderPaint);
    canvas.drawPath(roadPath, roadPaint);

    // Linha de navegação GPS (Verde Pinheiro)
    final routePaint = Paint()
      ..color = ConvivaColors.pineGreen
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(roadPath, routePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
