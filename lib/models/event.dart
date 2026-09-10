import 'package:flutter/material.dart';
import '../core/colors.dart';

enum EventStatus { upcoming, full, completed }

class EventParticipant {
  final String id;
  final String name;
  final String initials;
  final String timeAgo;
  final String? phone;
  bool isFriend;
  bool isPresent; // Para lista de presença do organizador

  EventParticipant({
    required this.id,
    required this.name,
    required this.initials,
    required this.timeAgo,
    this.phone,
    this.isFriend = false,
    this.isPresent = false,
  });
}

class ConvivaEvent {
  final String id;
  String title;
  String dateFormatted; // Ex: "Sábado, 14 de setembro · 14h00"
  String location;
  String distance;
  String category;
  String description;
  EventStatus status;
  int confirmedCount;
  int maxSpots;
  final String organizerId;
  List<EventParticipant> participants;
  bool isUserParticipating;
  bool userConfirmedAttendance; // Se idoso confirmou presença pós-evento

  ConvivaEvent({
    required this.id,
    required this.title,
    required this.dateFormatted,
    required this.location,
    required this.distance,
    required this.category,
    required this.description,
    required this.status,
    required this.confirmedCount,
    required this.maxSpots,
    required this.organizerId,
    required this.participants,
    this.isUserParticipating = false,
    this.userConfirmedAttendance = false,
  });

  Color get headerColor {
    switch (status) {
      case EventStatus.upcoming:
        return ConvivaColors.pineGreen;
      case EventStatus.full:
        return ConvivaColors.terracotta;
      case EventStatus.completed:
        return ConvivaColors.ochre;
    }
  }

  String get statusBadgeLabel {
    switch (status) {
      case EventStatus.upcoming:
        return 'Em breve';
      case EventStatus.full:
        return 'Lotado';
      case EventStatus.completed:
        return 'Aconteceu';
    }
  }

  Color get statusBadgeBg {
    switch (status) {
      case EventStatus.upcoming:
        return ConvivaColors.pineGreenLight;
      case EventStatus.full:
        return ConvivaColors.terracottaLight;
      case EventStatus.completed:
        return ConvivaColors.ochreLight;
    }
  }

  Color get statusBadgeTextColor {
    switch (status) {
      case EventStatus.upcoming:
        return ConvivaColors.pineGreenText;
      case EventStatus.full:
        return ConvivaColors.terracottaDark;
      case EventStatus.completed:
        return ConvivaColors.ochreDark;
    }
  }

  String get actionCardText {
    if (isUserParticipating) {
      return 'Você está participando ✓';
    }
    switch (status) {
      case EventStatus.upcoming:
        return 'Ver detalhes e confirmar presença →';
      case EventStatus.full:
        return 'Ver quem vai participar →';
      case EventStatus.completed:
        return 'Confirme se você esteve lá →';
    }
  }

  Color get actionCardTextColor {
    if (isUserParticipating) {
      return ConvivaColors.pineGreen;
    }
    switch (status) {
      case EventStatus.upcoming:
        return ConvivaColors.pineGreenText;
      case EventStatus.full:
        return ConvivaColors.terracotta;
      case EventStatus.completed:
        return ConvivaColors.ochreDark;
    }
  }
}
