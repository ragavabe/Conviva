import 'package:flutter/material.dart';
import '../core/colors.dart';

enum RideStatus { requested, accepted, inProgress, completed, cancelled }

class RideRequest {
  final String id;
  final String eventId;
  final String eventTitle;
  final String passengerId;
  final String passengerName;
  final String passengerPhone;
  final String pickupAddress;
  final String destinationAddress;
  final String scheduledTime;
  RideStatus status;
  String? driverName;

  RideRequest({
    required this.id,
    required this.eventId,
    required this.eventTitle,
    required this.passengerId,
    required this.passengerName,
    required this.passengerPhone,
    required this.pickupAddress,
    required this.destinationAddress,
    required this.scheduledTime,
    this.status = RideStatus.requested,
    this.driverName,
  });

  String get statusLabel {
    switch (status) {
      case RideStatus.requested:
        return 'Aguardando motorista';
      case RideStatus.accepted:
        return 'Motorista a caminho';
      case RideStatus.inProgress:
        return 'Em viagem';
      case RideStatus.completed:
        return 'Concluída com sucesso';
      case RideStatus.cancelled:
        return 'Cancelada';
    }
  }

  Color get statusColor {
    switch (status) {
      case RideStatus.requested:
        return ConvivaColors.terracotta;
      case RideStatus.accepted:
        return ConvivaColors.ochre;
      case RideStatus.inProgress:
        return Colors.blue.shade700;
      case RideStatus.completed:
        return ConvivaColors.pineGreen;
      case RideStatus.cancelled:
        return Colors.grey.shade600;
    }
  }
}
