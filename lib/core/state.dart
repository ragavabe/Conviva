import 'package:flutter/material.dart';
import '../models/app_user.dart';
import '../models/event.dart';
import '../models/ride.dart';
import 'services/facebook_auth_service.dart';

class ConvivaState extends ChangeNotifier {
  static final ConvivaState instance = ConvivaState._internal();
  factory ConvivaState() => instance;

  ConvivaState._internal() {
    _initSeedData();
  }

  // Usuário atualmente autenticado
  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;

  // Lista de eventos
  final List<ConvivaEvent> _events = [];
  List<ConvivaEvent> get events => List.unmodifiable(_events);

  // Lista de solicitações de carona
  final List<RideRequest> _rides = [];
  List<RideRequest> get rides => List.unmodifiable(_rides);

  // Acessibilidade: Tamanho de fonte ampliado para idosos
  double _textScaleFactor = 1.0;
  double get textScaleFactor => _textScaleFactor;
  bool get isLargeText => _textScaleFactor > 1.1;

  void toggleTextScale() {
    _textScaleFactor = _textScaleFactor == 1.0 ? 1.25 : 1.0;
    notifyListeners();
  }

  // Assistente de Voz / Leitura de Tela (Audio Assist)
  bool _isSpeaking = false;
  String? _currentSpeech;
  bool get isSpeaking => _isSpeaking;
  String? get currentSpeech => _currentSpeech;

  void speak(String text) {
    _isSpeaking = true;
    _currentSpeech = text;
    notifyListeners();
  }

  void stopSpeaking() {
    _isSpeaking = false;
    _currentSpeech = null;
    notifyListeners();
  }

  void _initSeedData() {
    // Inicia sem usuário autenticado para exibir a tela de login como porta de entrada
    _currentUser = null;

    // 2. Participantes idosos com iniciais elegantes (como nos mockups 02, 03, 04)
    final p1 = EventParticipant(
      id: 'p1',
      name: 'José Ribeiro',
      initials: 'JR',
      timeAgo: 'Confirmou há 2 dias',
      phone: '(11) 97123-4567',
      isPresent: true,
    );
    final p2 = EventParticipant(
      id: 'p2',
      name: 'Ana Cordeiro',
      initials: 'AC',
      timeAgo: 'Confirmou hoje',
      phone: '(11) 98234-5678',
      isPresent: true,
    );
    final p3 = EventParticipant(
      id: 'p3',
      name: 'Eduardo Melo',
      initials: 'EM',
      timeAgo: 'Confirmou ontem',
      phone: '(11) 99345-6789',
      isPresent: false,
    );
    final p4 = EventParticipant(
      id: 'p4',
      name: 'Lúcia Soares',
      initials: 'LS',
      timeAgo: 'Amigo no Conviva',
      phone: '(11) 96456-7890',
      isFriend: true,
      isPresent: true,
    );
    final p5 = EventParticipant(
      id: 'p5',
      name: 'Paulo Nogueira',
      initials: 'PN',
      timeAgo: 'Participante frequente',
      phone: '(11) 95567-8901',
      isFriend: false,
      isPresent: false,
    );
    final p6 = EventParticipant(
      id: 'p6',
      name: 'Rita Ferreira',
      initials: 'RF',
      timeAgo: 'Amigo no Conviva',
      phone: '(11) 94678-9012',
      isFriend: true,
      isPresent: true,
    );
    final p7 = EventParticipant(
      id: 'p7',
      name: 'Helena Bueno',
      initials: 'HB',
      timeAgo: 'Esteve presente',
      phone: '(11) 93789-0123',
      isPresent: true,
    );
    final p8 = EventParticipant(
      id: 'p8',
      name: 'Tomás Albuquerque',
      initials: 'TA',
      timeAgo: 'Esteve presente',
      phone: '(11) 92890-1234',
      isPresent: true,
    );

    // 3. Eventos fiéis aos PNGs da pasta
    _events.add(
      ConvivaEvent(
        id: 'ev_1',
        title: 'Bazar de Artesanato',
        dateFormatted: 'Sábado, 14 de setembro · 14h00',
        location: 'Centro Comunitário Jardim das Flores',
        distance: '1,2 km de você',
        category: 'Oficina & Bazar',
        description:
            'Uma tarde para conhecer trabalhos feitos à mão por artesãos da região, tomar um café e conversar. Entrada gratuita, com direito a lanche.',
        status: EventStatus.upcoming,
        confirmedCount: 18,
        maxSpots: 30,
        organizerId: 'org_carlos',
        participants: [p1, p2, p3, p4],
        isUserParticipating: false,
      ),
    );

    _events.add(
      ConvivaEvent(
        id: 'ev_2',
        title: 'Tarde de Bingo Solidário',
        dateFormatted: 'Quinta, 11 de setembro · 15h30',
        location: 'Salão Paroquial Santa Luzia',
        distance: '2,8 km de você',
        category: 'Jogos & Prêmios',
        description:
            'As vagas para este evento já se esgotaram. Você pode entrar na lista de espera ou conhecer quem vai participar.',
        status: EventStatus.full,
        confirmedCount: 40,
        maxSpots: 40,
        organizerId: 'org_carlos',
        participants: [p4, p5, p6],
        isUserParticipating: false,
      ),
    );

    _events.add(
      ConvivaEvent(
        id: 'ev_3',
        title: 'Caminhada no Parque',
        dateFormatted: 'Domingo, 7 de setembro · 8h00',
        location: 'Parque Ecológico Córrego Grande',
        distance: '3,5 km de você',
        category: 'Saúde & Ar Livre',
        description:
            'Encontro matinal leve com alongamento monitorado por fisioterapeuta, caminhada no bosque e piquenique de frutas frescas.',
        status: EventStatus.completed,
        confirmedCount: 24,
        maxSpots: 50,
        organizerId: 'org_carlos',
        participants: [p7, p8, p1],
        isUserParticipating: true,
        userConfirmedAttendance: true,
      ),
    );

    _events.add(
      ConvivaEvent(
        id: 'ev_4',
        title: 'Baile e Coral da Terceira Idade',
        dateFormatted: 'Sexta, 20 de setembro · 16h00',
        location: 'Clube dos Pioneiros',
        distance: '4,1 km de você',
        category: 'Música & Dança',
        description:
            'Apresentação especial do coral e baile com músicas clássicas dos anos 60, 70 e 80. Venha dançar ou apenas ouvir boa música!',
        status: EventStatus.upcoming,
        confirmedCount: 29,
        maxSpots: 60,
        organizerId: 'org_carlos',
        participants: [p2, p3, p6],
        isUserParticipating: false,
      ),
    );

    // 4. Caronas de demonstração
    _rides.add(
      RideRequest(
        id: 'ride_1',
        eventId: 'ev_1',
        eventTitle: 'Bazar de Artesanato',
        passengerId: 'user_marta',
        passengerName: 'Dona Marta',
        passengerPhone: '(11) 98765-4321',
        pickupAddress: 'Rua das Camélias, 120 - Jardim das Flores',
        destinationAddress: 'Centro Comunitário Jardim das Flores',
        scheduledTime: '13:30',
        status: RideStatus.requested,
      ),
    );

    _rides.add(
      RideRequest(
        id: 'ride_2',
        eventId: 'ev_4',
        eventTitle: 'Baile e Coral',
        passengerId: 'p1',
        passengerName: 'José Ribeiro',
        passengerPhone: '(11) 97123-4567',
        pickupAddress: 'Av. Paulista, 1500 - Bela Vista',
        destinationAddress: 'Clube dos Pioneiros',
        scheduledTime: '15:15',
        status: RideStatus.accepted,
        driverName: 'Roberto Santos',
      ),
    );
  }

  // --- MÉTODOS DE AUTENTICAÇÃO E PERFIL ---
  void login(AppUser user) {
    _currentUser = user;
    notifyListeners();
  }

  void logout() {
    FacebookAuthService.instance.logOut();
    _currentUser = null;
    notifyListeners();
  }

  void switchRole(UserRole role) {
    if (role == UserRole.senior) {
      _currentUser = AppUser(
        id: 'user_marta',
        name: 'Dona Marta',
        email: 'marta@conviva.com',
        role: UserRole.senior,
        phone: '(11) 98765-4321',
        address: 'Rua das Camélias, 120 - Jardim das Flores',
      );
    } else if (role == UserRole.organizer) {
      _currentUser = AppUser(
        id: 'org_carlos',
        name: 'Carlos Silva (Organizador)',
        email: 'carlos@conviva.com',
        role: UserRole.organizer,
        document: '28.491.029/0001-84',
      );
    } else {
      _currentUser = AppUser(
        id: 'driver_roberto',
        name: 'Roberto Santos (Motorista)',
        email: 'roberto@conviva.com',
        role: UserRole.driver,
        accessCode: 'CONVIVA2026',
      );
    }
    notifyListeners();
  }

  // --- MÉTODOS DE EVENTOS ---
  void toggleEventParticipation(String eventId) {
    final eventIndex = _events.indexWhere((e) => e.id == eventId);
    if (eventIndex == -1) return;

    final event = _events[eventIndex];
    if (event.isUserParticipating) {
      event.isUserParticipating = false;
      event.confirmedCount = (event.confirmedCount - 1).clamp(0, 9999);
      event.participants.removeWhere(
        (p) => p.id == (_currentUser?.id ?? 'user_marta'),
      );
    } else {
      event.isUserParticipating = true;
      event.confirmedCount += 1;
      event.participants.insert(
        0,
        EventParticipant(
          id: _currentUser?.id ?? 'user_marta',
          name: _currentUser?.name ?? 'Dona Marta',
          initials: _currentUser?.initials ?? 'DM',
          timeAgo: 'Confirmou agora',
          phone: _currentUser?.phone,
          isPresent: true,
        ),
      );
    }
    notifyListeners();
  }

  void toggleParticipantFriend(String eventId, String participantId) {
    final event = _events.firstWhere((e) => e.id == eventId);
    final participant = event.participants.firstWhere(
      (p) => p.id == participantId,
    );
    participant.isFriend = !participant.isFriend;
    notifyListeners();
  }

  void confirmPastAttendance(String eventId, bool didAttend) {
    final event = _events.firstWhere((e) => e.id == eventId);
    event.userConfirmedAttendance = didAttend;
    notifyListeners();
  }

  // Buffer para Desfazer Exclusão (Undo Delete)
  ConvivaEvent? _lastDeletedEvent;
  int? _lastDeletedIndex;
  List<RideRequest> _lastDeletedRides = [];

  bool get canUndoDelete => _lastDeletedEvent != null;

  void addEvent(ConvivaEvent newEvent) {
    _events.insert(0, newEvent);
    notifyListeners();
  }

  void updateEvent(ConvivaEvent updatedEvent) {
    final idx = _events.indexWhere((e) => e.id == updatedEvent.id);
    if (idx != -1) {
      _events[idx] = updatedEvent;
      notifyListeners();
    }
  }

  void updateEventStatus(String eventId, EventStatus newStatus) {
    final idx = _events.indexWhere((e) => e.id == eventId);
    if (idx != -1) {
      _events[idx].status = newStatus;
      notifyListeners();
    }
  }

  void duplicateEvent(String eventId) {
    final original = _events.firstWhere((e) => e.id == eventId);
    final copy = ConvivaEvent(
      id: 'ev_${DateTime.now().millisecondsSinceEpoch}',
      title: '${original.title} (Cópia)',
      dateFormatted: original.dateFormatted,
      location: original.location,
      distance: original.distance,
      category: original.category,
      description: original.description,
      status: original.status,
      confirmedCount: 0,
      maxSpots: original.maxSpots,
      organizerId: original.organizerId,
      participants: [],
      isUserParticipating: false,
      userConfirmedAttendance: false,
    );
    _events.insert(0, copy);
    notifyListeners();
  }

  void deleteEvent(String eventId) {
    final idx = _events.indexWhere((e) => e.id == eventId);
    if (idx != -1) {
      _lastDeletedEvent = _events[idx];
      _lastDeletedIndex = idx;
      _lastDeletedRides = _rides.where((r) => r.eventId == eventId).toList();

      _events.removeAt(idx);
      _rides.removeWhere((r) => r.eventId == eventId);
      notifyListeners();
    }
  }

  bool undoDeleteEvent() {
    if (_lastDeletedEvent != null) {
      final insertIdx = (_lastDeletedIndex ?? 0).clamp(0, _events.length);
      _events.insert(insertIdx, _lastDeletedEvent!);
      _rides.addAll(_lastDeletedRides);
      _lastDeletedEvent = null;
      _lastDeletedIndex = null;
      _lastDeletedRides = [];
      notifyListeners();
      return true;
    }
    return false;
  }

  void addParticipantToEvent(String eventId, EventParticipant participant) {
    final idx = _events.indexWhere((e) => e.id == eventId);
    if (idx != -1) {
      _events[idx].participants.insert(0, participant);
      _events[idx].confirmedCount += 1;
      notifyListeners();
    }
  }

  void removeParticipantFromEvent(String eventId, String participantId) {
    final idx = _events.indexWhere((e) => e.id == eventId);
    if (idx != -1) {
      final pIndex = _events[idx].participants.indexWhere((p) => p.id == participantId);
      if (pIndex != -1) {
        _events[idx].participants.removeAt(pIndex);
        _events[idx].confirmedCount = (_events[idx].confirmedCount - 1).clamp(0, 9999);
        notifyListeners();
      }
    }
  }

  void resetToMockupData() {
    _events.clear();
    _rides.clear();
    _initSeedData();
    notifyListeners();
  }

  void seedExtraEvents() {
    final p1 = EventParticipant(
      id: 'px1',
      name: 'Margarida Lima',
      initials: 'ML',
      timeAgo: 'Confirmou há 1 hora',
      phone: '(11) 98111-2233',
      isPresent: true,
    );
    final p2 = EventParticipant(
      id: 'px2',
      name: 'Geraldo Antunes',
      initials: 'GA',
      timeAgo: 'Confirmou ontem',
      phone: '(11) 97222-3344',
      isPresent: true,
    );
    _events.add(
      ConvivaEvent(
        id: 'ev_extra_1',
        title: 'Oficina de Jardinagem e Plantas',
        dateFormatted: 'Quarta, 25 de setembro · 10h00',
        location: 'Horta Comunitária das Palmeiras',
        distance: '0,9 km de você',
        category: 'Natureza & Horta',
        description:
            'Aprenda a cuidar de suculentas, ervas medicinais e temperos caseiros. Todo material incluso com café da manhã colaborativo.',
        status: EventStatus.upcoming,
        confirmedCount: 14,
        maxSpots: 20,
        organizerId: 'org_carlos',
        participants: [p1, p2],
      ),
    );
    _events.add(
      ConvivaEvent(
        id: 'ev_extra_2',
        title: 'Clube da Leitura & Memórias',
        dateFormatted: 'Segunda, 30 de setembro · 14h30',
        location: 'Biblioteca Municipal Central',
        distance: '2,1 km de você',
        category: 'Cultura & Livros',
        description:
            'Roda de conversa sobre contos brasileiros clássicos e memórias da infância. Ambiente com acessibilidade e poltronas confortáveis.',
        status: EventStatus.upcoming,
        confirmedCount: 8,
        maxSpots: 15,
        organizerId: 'org_carlos',
        participants: [p1],
      ),
    );
    notifyListeners();
  }

  void togglePresenceInAttendanceList(
    String eventId,
    String participantId,
    bool isPresent,
  ) {
    final event = _events.firstWhere((e) => e.id == eventId);
    final participant = event.participants.firstWhere(
      (p) => p.id == participantId,
    );
    participant.isPresent = isPresent;
    notifyListeners();
  }

  // --- MÉTODOS DE TRANSPORTE E CORRIDAS ---
  RideRequest? getRideForEvent(String eventId) {
    try {
      return _rides.firstWhere(
        (r) =>
            r.eventId == eventId &&
            r.passengerId == (_currentUser?.id ?? 'user_marta') &&
            r.status != RideStatus.cancelled,
      );
    } catch (_) {
      return null;
    }
  }

  void requestRide({
    required String eventId,
    required String eventTitle,
    required String destinationAddress,
    String pickupAddress = 'Rua das Palmeiras, 120 - Apto 42',
    String scheduledTime = '13h30',
  }) {
    final newRide = RideRequest(
      id: 'ride_${DateTime.now().millisecondsSinceEpoch}',
      eventId: eventId,
      eventTitle: eventTitle,
      passengerId: _currentUser?.id ?? 'user_marta',
      passengerName: _currentUser?.name ?? 'Dona Marta',
      passengerPhone: _currentUser?.phone ?? '(11) 98765-4321',
      pickupAddress: pickupAddress,
      destinationAddress: destinationAddress,
      scheduledTime: scheduledTime,
      status: RideStatus.requested,
    );
    _rides.insert(0, newRide);
    notifyListeners();
  }

  void cancelRide(String rideId) {
    final ride = _rides.firstWhere((r) => r.id == rideId);
    ride.status = RideStatus.cancelled;
    notifyListeners();
  }

  void acceptRide(String rideId, String driverName) {
    final ride = _rides.firstWhere((r) => r.id == rideId);
    ride.status = RideStatus.accepted;
    ride.driverName = driverName;
    notifyListeners();
  }

  void updateRideStatus(String rideId, RideStatus newStatus) {
    final ride = _rides.firstWhere((r) => r.id == rideId);
    ride.status = newStatus;
    notifyListeners();
  }
}
