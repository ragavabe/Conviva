import 'package:flutter/material.dart';

// ============================================================================
// CONVIVA - APLICATIVO MOBILE COMPLETO (ARQUITETURA UNIFICADA EM 1 ARQUIVO)
// Combate à solidão na terceira idade, incentivo a eventos e mobilidade solidária
// Cores e estética fiéis aos mockups: 01-home, 02-evento-futuro, 03-lotado, 04-realizado
// ============================================================================

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ConvivaApp());
}

// ============================================================================
// 1. DESIGN SYSTEM & PALETA DE CORES (Baseado nos mockups PNG)
// ============================================================================
class ConvivaColors {
  // Fundo creme suave e acolhedor (presente em todas as telas)
  static const Color background = Color(0xFFFAF6EE);
  static const Color surface = Colors.white;
  static const Color border = Color(0xFFE8E1D3);
  static const Color borderSubtle = Color(0xFFF0EBE1);

  // Verde Pinheiro / Floresta (Identidade principal, botões e status "Em breve")
  static const Color pineGreen = Color(0xFF264E41);
  static const Color pineGreenDark = Color(0xFF1B3B31);
  static const Color pineGreenLight = Color(0xFFE2EFEA);
  static const Color pineGreenText = Color(0xFF1E453A);

  // Terracota / Ferrugem (Badge "Lotado" e detalhes de atenção)
  static const Color terracotta = Color(0xFFC1532F);
  static const Color terracottaLight = Color(0xFFFDE8DE);
  static const Color terracottaDark = Color(0xFF9E3E20);

  // Ocre / Dourado / Âmbar (Badge "Aconteceu" e eventos passados)
  static const Color ochre = Color(0xFFAC8337);
  static const Color ochreLight = Color(0xFFF7EEDC);
  static const Color ochreDark = Color(0xFF8C6524);

  // Textos e Tipografia (Alto contraste para acessibilidade de idosos)
  static const Color textPrimary = Color(0xFF222623);
  static const Color textSecondary = Color(0xFF5E6460);
  static const Color textMuted = Color(0xFF888E8A);
  static const Color divider = Color(0xFFEBE5D9);

  // Avatar e ícones neutros
  static const Color avatarBg = Color(0xFFEFE8D8);
  static const Color avatarText = Color(0xFF264E41);
}

class ConvivaTypography {
  // Tipografia serifada elegante para títulos (fiel aos mockups: 01-home, etc.)
  static const TextStyle titleSerifLarge = TextStyle(
    fontFamily: 'serif',
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: ConvivaColors.textPrimary,
    letterSpacing: -0.3,
  );

  static const TextStyle titleSerifMedium = TextStyle(
    fontFamily: 'serif',
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: ConvivaColors.textPrimary,
    letterSpacing: -0.2,
  );

  static const TextStyle titleSerifSmall = TextStyle(
    fontFamily: 'serif',
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: ConvivaColors.textPrimary,
  );

  // Tipografia sans-serif limpa e ampliada para idosos
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 17,
    color: ConvivaColors.textPrimary,
    height: 1.45,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 15,
    color: ConvivaColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 13,
    color: ConvivaColors.textMuted,
  );

  static const TextStyle button = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.2,
  );
}

// ============================================================================
// 2. MODELOS DE DADOS (USER, PARTICIPANT, EVENT, RIDE)
// ============================================================================

enum UserRole { senior, organizer, driver }

enum EventStatus { upcoming, full, completed }

class AppUser {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? phone;
  final String? address;
  final String? document; // CPF ou CNPJ para organizador
  final String? accessCode; // Código do motorista

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.address,
    this.document,
    this.accessCode,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return 'CO';
  }
}

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
}

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

// ============================================================================
// 3. REPOSITÓRIO E GERENCIADOR DE ESTADO LOCAL (MOCK DATA SERVICE)
// ============================================================================

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

  void _initSeedData() {
    // 1. Usuário idoso padrão (fiel ao mockup: Dona Marta)
    final donaMarta = AppUser(
      id: 'user_marta',
      name: 'Dona Marta',
      email: 'marta@conviva.com',
      role: UserRole.senior,
      phone: '(11) 98765-4321',
      address: 'Rua das Camélias, 120 - Jardim das Flores',
    );
    _currentUser = donaMarta;

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
    // Evento 1: Fiel a 01-home.png e 02-evento-futuro.png
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

    // Evento 2: Fiel a 01-home.png e 03-evento-lotado.png
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

    // Evento 3: Fiel a 01-home.png e 04-evento-realizado.png
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

    // Evento 4: Encontro Musical e Coral
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
      // Cancelar participação
      event.isUserParticipating = false;
      event.confirmedCount = (event.confirmedCount - 1).clamp(0, 9999);
      event.participants.removeWhere(
        (p) => p.id == (_currentUser?.id ?? 'user_marta'),
      );
    } else {
      // Confirmar participação
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

  void deleteEvent(String eventId) {
    _events.removeWhere((e) => e.id == eventId);
    _rides.removeWhere((r) => r.eventId == eventId);
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
    required String pickupAddress,
    required String scheduledTime,
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

// ============================================================================
// 4. APLICATIVO PRINCIPAL COM TEMA MATERIAL 3 ACOLHEDOR
// ============================================================================

class ConvivaApp extends StatelessWidget {
  const ConvivaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ConvivaState.instance,
      builder: (context, _) {
        return MaterialApp(
          title: 'CONVIVA',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: ConvivaColors.background,
            colorScheme: ColorScheme.fromSeed(
              seedColor: ConvivaColors.pineGreen,
              primary: ConvivaColors.pineGreen,
              surface: ConvivaColors.background,
              onSurface: ConvivaColors.textPrimary,
              error: ConvivaColors.terracotta,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: ConvivaColors.background,
              elevation: 0,
              scrolledUnderElevation: 0,
              iconTheme: IconThemeData(
                color: ConvivaColors.textPrimary,
                size: 26,
              ),
              titleTextStyle: ConvivaTypography.titleSerifMedium,
            ),
            cardTheme: CardThemeData(
              color: ConvivaColors.surface,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
                side: const BorderSide(color: ConvivaColors.border, width: 1.2),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: ConvivaColors.pineGreen,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: ConvivaTypography.button,
                elevation: 0,
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                foregroundColor: ConvivaColors.textPrimary,
                minimumSize: const Size(double.infinity, 52),
                side: const BorderSide(color: ConvivaColors.border, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: ConvivaTypography.button.copyWith(fontSize: 16),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: ConvivaColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: ConvivaColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: ConvivaColors.pineGreen,
                  width: 2,
                ),
              ),
              labelStyle: const TextStyle(
                color: ConvivaColors.textSecondary,
                fontSize: 16,
              ),
              hintStyle: const TextStyle(
                color: ConvivaColors.textMuted,
                fontSize: 15,
              ),
            ),
          ),
          home: const RootGate(),
        );
      },
    );
  }
}

// Roteador dinâmico de acordo com o papel do usuário autenticado
class RootGate extends StatelessWidget {
  const RootGate({super.key});

  @override
  Widget build(BuildContext context) {
    final state = ConvivaState.instance;
    final user = state.currentUser;

    if (user == null) {
      return const LoginScreen();
    }

    switch (user.role) {
      case UserRole.senior:
        return const SeniorMainShell();
      case UserRole.organizer:
        return const OrganizerMainShell();
      case UserRole.driver:
        return const DriverMainShell();
    }
  }
}

// ============================================================================
// 5. TELAS DE AUTENTICAÇÃO E CADASTROS DIFERENCIADOS
// ============================================================================

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'marta@conviva.com');
  final _passwordController = TextEditingController(text: '123456');
  final _formKey = GlobalKey<FormState>();

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim().toLowerCase();
      final state = ConvivaState.instance;

      if (email.contains('carlos') || email.contains('org')) {
        state.switchRole(UserRole.organizer);
      } else if (email.contains('roberto') ||
          email.contains('mot') ||
          email.contains('motorista')) {
        state.switchRole(UserRole.driver);
      } else {
        state.switchRole(UserRole.senior);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Bem-vindo(a) de volta ao CONVIVA!',
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: ConvivaColors.pineGreen,
        ),
      );
    }
  }

  void _showSignupOptionsModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: ConvivaColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: ConvivaColors.border,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Escolha seu perfil no CONVIVA',
              textAlign: TextAlign.center,
              style: ConvivaTypography.titleSerifMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Cada perfil possui uma experiência adaptada às suas necessidades.',
              textAlign: TextAlign.center,
              style: ConvivaTypography.bodyMedium,
            ),
            const SizedBox(height: 24),
            _buildRoleSelectionTile(
              title: 'Usuário / Idoso',
              description:
                  'Descobrir eventos, interagir e solicitar transporte',
              icon: Icons.person_rounded,
              color: ConvivaColors.pineGreen,
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SeniorSignupScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildRoleSelectionTile(
              title: 'Organizador de Eventos',
              description: 'Criar atividades, divulgar e gerenciar presença',
              icon: Icons.event_available_rounded,
              color: ConvivaColors.terracotta,
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OrganizerSignupScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildRoleSelectionTile(
              title: 'Motorista Solidário',
              description: 'Apoiar na mobilidade e levar idosos aos eventos',
              icon: Icons.directions_car_filled_rounded,
              color: ConvivaColors.ochre,
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DriverSignupScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleSelectionTile({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: ConvivaColors.border, width: 1.2),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: ConvivaColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: ConvivaColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: ConvivaColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo / Marca CONVIVA
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: ConvivaColors.pineGreen,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.favorite_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'CONVIVA',
                            style: TextStyle(
                              fontFamily: 'serif',
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Conectando pessoas.\nMovendo vidas.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: ConvivaColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Card de Demonstração Rápida para o Hackathon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ConvivaColors.pineGreenLight,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: ConvivaColors.pineGreen.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.touch_app_rounded,
                              size: 20,
                              color: ConvivaColors.pineGreen,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Acesso Rápido de Demonstração:',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: ConvivaColors.pineGreenText,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _buildQuickLoginChip(
                                label: '👵 Idosa',
                                onTap: () => ConvivaState.instance.switchRole(
                                  UserRole.senior,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildQuickLoginChip(
                                label: '📋 Organizador',
                                onTap: () => ConvivaState.instance.switchRole(
                                  UserRole.organizer,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildQuickLoginChip(
                                label: '🚗 Motorista',
                                onTap: () => ConvivaState.instance.switchRole(
                                  UserRole.driver,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Campos de Login Tradicionais
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(fontSize: 17),
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: ConvivaColors.textSecondary,
                      ),
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Informe seu e-mail' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(fontSize: 17),
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: Icon(
                        Icons.lock_outline_rounded,
                        color: ConvivaColors.textSecondary,
                      ),
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Informe sua senha' : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _handleLogin,
                    child: const Text('Entrar'),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: _showSignupOptionsModal,
                    child: const Text('Criar conta'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickLoginChip({
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ConvivaColors.pineGreen.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: ConvivaColors.pineGreenText,
          ),
        ),
      ),
    );
  }
}

// 2. CADASTRO DO USUÁRIO IDOSO
class SeniorSignupScreen extends StatefulWidget {
  const SeniorSignupScreen({super.key});

  @override
  State<SeniorSignupScreen> createState() => _SeniorSignupScreenState();
}

class _SeniorSignupScreenState extends State<SeniorSignupScreen> {
  final _nameController = TextEditingController(text: 'Dona Marta');
  final _addressController = TextEditingController(
    text: 'Rua das Camélias, 120 - Jardim das Flores',
  );
  final _phoneController = TextEditingController(text: '(11) 98765-4321');
  final _emailController = TextEditingController(text: 'marta@conviva.com');
  final _passwordController = TextEditingController(text: '123456');
  final _formKey = GlobalKey<FormState>();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final user = AppUser(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        role: UserRole.senior,
      );
      ConvivaState.instance.login(user);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Usuário')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Boas-vindas ao CONVIVA!',
                style: ConvivaTypography.titleSerifMedium,
              ),
              const SizedBox(height: 6),
              const Text(
                'Preencha seus dados para encontrar eventos perto de você.',
                style: ConvivaTypography.bodyMedium,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(fontSize: 17),
                decoration: const InputDecoration(
                  labelText: 'Nome completo',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (v) => v!.isEmpty ? 'Informe seu nome' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                style: const TextStyle(fontSize: 17),
                decoration: const InputDecoration(
                  labelText: 'Endereço residencial',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                validator: (v) => v!.isEmpty ? 'Informe seu endereço' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontSize: 17),
                decoration: const InputDecoration(
                  labelText: 'Telefone / WhatsApp',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                validator: (v) => v!.isEmpty ? 'Informe seu telefone' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(fontSize: 17),
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (v) => v!.isEmpty ? 'Informe seu e-mail' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(fontSize: 17),
                decoration: const InputDecoration(
                  labelText: 'Senha de acesso',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                validator: (v) => v!.isEmpty ? 'Crie uma senha' : null,
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Criar conta e Começar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 3. CADASTRO DO ORGANIZADOR
class OrganizerSignupScreen extends StatefulWidget {
  const OrganizerSignupScreen({super.key});

  @override
  State<OrganizerSignupScreen> createState() => _OrganizerSignupScreenState();
}

class _OrganizerSignupScreenState extends State<OrganizerSignupScreen> {
  final _nameController = TextEditingController(
    text: 'Centro Comunitário Jardim das Flores',
  );
  final _docController = TextEditingController(text: '12.345.678/0001-90');
  final _emailController = TextEditingController(
    text: 'contato@centrojardim.org',
  );
  final _passwordController = TextEditingController(text: '123456');
  final _formKey = GlobalKey<FormState>();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final user = AppUser(
        id: 'org_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        document: _docController.text.trim(),
        email: _emailController.text.trim(),
        role: UserRole.organizer,
      );
      ConvivaState.instance.login(user);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Organizador')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Promova Encontros Comunitários',
                style: ConvivaTypography.titleSerifMedium,
              ),
              const SizedBox(height: 6),
              const Text(
                'Cadastre sua entidade ou iniciativa para divulgar eventos para idosos.',
                style: ConvivaTypography.bodyMedium,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(fontSize: 17),
                decoration: const InputDecoration(
                  labelText: 'Nome do Responsável ou Entidade',
                  prefixIcon: Icon(Icons.business_outlined),
                ),
                validator: (v) => v!.isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _docController,
                style: const TextStyle(fontSize: 17),
                decoration: const InputDecoration(
                  labelText: 'CPF ou CNPJ',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                validator: (v) => v!.isEmpty ? 'Informe CPF ou CNPJ' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(fontSize: 17),
                decoration: const InputDecoration(
                  labelText: 'E-mail corporativo / institucional',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (v) => v!.isEmpty ? 'Informe o e-mail' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(fontSize: 17),
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                validator: (v) => v!.isEmpty ? 'Crie uma senha' : null,
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ConvivaColors.terracotta,
                ),
                child: const Text('Criar conta de Organizador'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 4. CADASTRO DO MOTORISTA
class DriverSignupScreen extends StatefulWidget {
  const DriverSignupScreen({super.key});

  @override
  State<DriverSignupScreen> createState() => _DriverSignupScreenState();
}

class _DriverSignupScreenState extends State<DriverSignupScreen> {
  final _nameController = TextEditingController(text: 'Roberto Santos');
  final _codeController = TextEditingController(text: 'CONVIVA2026');
  final _emailController = TextEditingController(text: 'roberto@conviva.com');
  final _passwordController = TextEditingController(text: '123456');
  final _formKey = GlobalKey<FormState>();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final code = _codeController.text.trim().toUpperCase();
      if (code != 'CONVIVA2026' && code != 'CONVIVA') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Código de acesso inválido. Use CONVIVA2026 para demonstração.',
            ),
            backgroundColor: ConvivaColors.terracotta,
          ),
        );
        return;
      }
      final user = AppUser(
        id: 'driver_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        accessCode: code,
        email: _emailController.text.trim(),
        role: UserRole.driver,
      );
      ConvivaState.instance.login(user);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Motorista')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Motorista Parceiro Solidário',
                style: ConvivaTypography.titleSerifMedium,
              ),
              const SizedBox(height: 6),
              const Text(
                'Ajude a transportar pessoas idosas com segurança e conforto até os encontros.',
                style: ConvivaTypography.bodyMedium,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(fontSize: 17),
                decoration: const InputDecoration(
                  labelText: 'Nome completo',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (v) => v!.isEmpty ? 'Informe seu nome' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _codeController,
                style: const TextStyle(fontSize: 17),
                decoration: const InputDecoration(
                  labelText: 'Código de Acesso do Sistema',
                  helperText: 'Código do administrador (Ex: CONVIVA2026)',
                  prefixIcon: Icon(Icons.vpn_key_outlined),
                ),
                validator: (v) =>
                    v!.isEmpty ? 'Informe o código de acesso' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(fontSize: 17),
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (v) => v!.isEmpty ? 'Informe o e-mail' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(fontSize: 17),
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                validator: (v) => v!.isEmpty ? 'Crie uma senha' : null,
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ConvivaColors.ochre,
                ),
                child: const Text('Entrar / Cadastrar Motorista'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 6. MÓDULO DO USUÁRIO / IDOSO (SHELL, HOME, DETALHES, MEUS EVENTOS, TRANSPORTE)
// ============================================================================

class SeniorMainShell extends StatefulWidget {
  const SeniorMainShell({super.key});

  @override
  State<SeniorMainShell> createState() => _SeniorMainShellState();
}

class _SeniorMainShellState extends State<SeniorMainShell> {
  int _currentIndex = 0;

  final _pages = const [
    SeniorHomeScreen(),
    SeniorMyEventsScreen(),
    SeniorTransportScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        backgroundColor: ConvivaColors.background,
        indicatorColor: ConvivaColors.pineGreenLight,
        elevation: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
              size: 28,
              color: ConvivaColors.textSecondary,
            ),
            selectedIcon: Icon(
              Icons.home_rounded,
              size: 28,
              color: ConvivaColors.pineGreen,
            ),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.calendar_today_outlined,
              size: 25,
              color: ConvivaColors.textSecondary,
            ),
            selectedIcon: Icon(
              Icons.calendar_month_rounded,
              size: 25,
              color: ConvivaColors.pineGreen,
            ),
            label: 'Eventos',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.directions_car_outlined,
              size: 28,
              color: ConvivaColors.textSecondary,
            ),
            selectedIcon: Icon(
              Icons.directions_car_filled_rounded,
              size: 28,
              color: ConvivaColors.pineGreen,
            ),
            label: 'Transporte',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.person_outline_rounded,
              size: 28,
              color: ConvivaColors.textSecondary,
            ),
            selectedIcon: Icon(
              Icons.person_rounded,
              size: 28,
              color: ConvivaColors.pineGreen,
            ),
            label: 'Meu Perfil',
          ),
        ],
      ),
    );
  }
}

// TELA INICIAL DO IDOSO - IDÊNTICA AO MOCKUP 01-home.png
class SeniorHomeScreen extends StatelessWidget {
  const SeniorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = ConvivaState.instance;

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final user = state.currentUser;
        final events = state.events;

        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                // Cabeçalho acolhedor com Saudação e Mãozinha 👋 (01-home.png)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Olá, ${user?.name ?? 'Dona Marta'}',
                                style: ConvivaTypography.titleSerifLarge,
                              ),
                              const SizedBox(width: 8),
                              const Text('👋', style: TextStyle(fontSize: 26)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Veja o que está acontecendo perto de você',
                            style: TextStyle(
                              fontSize: 16,
                              color: ConvivaColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Indicador de perfil ativo
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: ConvivaColors.pineGreenLight,
                      child: Text(
                        user?.initials ?? 'DM',
                        style: const TextStyle(
                          fontFamily: 'serif',
                          fontWeight: FontWeight.bold,
                          color: ConvivaColors.pineGreen,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Seção "Eventos próximos"
                Row(
                  children: const [
                    Text(
                      'Eventos próximos',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ConvivaColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Lista de Cards de Eventos (01-home.png)
                ...events.map(
                  (event) => Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: EventCard(
                      event: event,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                EventDetailsScreen(eventId: event.id),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// CARD DE EVENTO FIEL AO 01-home.png E COM TODOS OS REQUISITOS DO BRIEFING
class EventCard extends StatelessWidget {
  final ConvivaEvent event;
  final VoidCallback onTap;

  const EventCard({super.key, required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
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
                // Topo do card: Título Serifado e Badge de Status
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        event.title,
                        style: ConvivaTypography.titleSerifMedium,
                      ),
                    ),
                    const SizedBox(width: 12),
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

                // Pequena descrição (item 5 do briefing)
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

                // Botão de Ação no Rodapé do Card com Seta Indicativa (01-home.png)
                Row(
                  children: [
                    Text(
                      event.actionCardText,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: event.isUserParticipating
                            ? ConvivaColors.pineGreen
                            : (event.status == EventStatus.full
                                  ? ConvivaColors.terracotta
                                  : (event.status == EventStatus.completed
                                        ? ConvivaColors.ochreDark
                                        : ConvivaColors.pineGreenText)),
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

// TELA DE DETALHES DO EVENTO (Fiel a 02-evento-futuro, 03-lotado e 04-realizado)
class EventDetailsScreen extends StatefulWidget {
  final String eventId;

  const EventDetailsScreen({super.key, required this.eventId});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ConvivaState.instance;

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final event = state.events.firstWhere(
          (e) => e.id == widget.eventId,
          orElse: () => state.events.first,
        );

        return Scaffold(
          backgroundColor: ConvivaColors.background,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // BANNER SUPERIOR COM COR DINÂMICA (Verde em 02, Terracota em 03, Ocre em 04)
                Container(
                  color: event.headerColor,
                  padding: const EdgeInsets.fromLTRB(20, 48, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Botão Voltar Circular Translúcido (fiel aos mockups)
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.22),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Título do Evento em Serif Grande Branco
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontFamily: 'serif',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),

                // CORPO DO EVENTO (Fundo Creme)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Bloco de Data e Horário com ícone em caixa
                      _buildInfoRow(
                        icon: Icons.calendar_today_outlined,
                        text: event.dateFormatted,
                      ),
                      const SizedBox(height: 14),

                      // Bloco de Local com ícone em caixa
                      _buildInfoRow(
                        icon: Icons.place_outlined,
                        text: event.location,
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 18),
                        child: Divider(
                          color: ConvivaColors.divider,
                          thickness: 1,
                        ),
                      ),

                      // Descrição do Evento
                      Text(
                        event.description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: ConvivaColors.textPrimary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // SEÇÃO DE BOTÕES DE AÇÃO ESPECÍFICOS POR STATUS DO EVENTO:
                      // Caso 1: Evento Futuro (02-evento-futuro.png)
                      if (event.status == EventStatus.upcoming) ...[
                        if (!event.isUserParticipating) ...[
                          ElevatedButton(
                            onPressed: () {
                              state.toggleEventParticipation(event.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Presença confirmada no "${event.title}"!',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  backgroundColor: ConvivaColors.pineGreen,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ConvivaColors.pineGreen,
                            ),
                            child: const Text('Confirmar presença'),
                          ),
                        ] else ...[
                          // Se já está participando
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: ConvivaColors.pineGreenLight,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: ConvivaColors.pineGreen),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: ConvivaColors.pineGreen,
                                  size: 24,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Você está participando!',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: ConvivaColors.pineGreenText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () {
                              state.toggleEventParticipation(event.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Participação cancelada.'),
                                ),
                              );
                            },
                            child: const Text(
                              'Cancelar participação',
                              style: TextStyle(
                                color: ConvivaColors.terracotta,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],

                      // Caso 2: Evento Lotado (03-evento-lotado.png)
                      if (event.status == EventStatus.full) ...[
                        OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Você foi adicionado à lista de espera com sucesso!',
                                  style: TextStyle(fontSize: 16),
                                ),
                                backgroundColor: ConvivaColors.terracotta,
                              ),
                            );
                          },
                          child: const Text('Entrar na lista de espera'),
                        ),
                      ],

                      // Caso 3: Evento Realizado (04-evento-realizado.png)
                      if (event.status == EventStatus.completed) ...[
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: ConvivaColors.ochreLight,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: ConvivaColors.ochre.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Este evento já aconteceu.',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: ConvivaColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Você esteve presente?',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: ConvivaColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        state.confirmPastAttendance(
                                          event.id,
                                          false,
                                        );
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Obrigado pelo feedback!',
                                            ),
                                          ),
                                        );
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                      ),
                                      child: const Text('Não estive'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        state.confirmPastAttendance(
                                          event.id,
                                          true,
                                        );
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: const Text(
                                              'Presença confirmada! Que ótimo ter você por lá.',
                                            ),
                                            backgroundColor:
                                                ConvivaColors.pineGreen,
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            ConvivaColors.pineGreen,
                                      ),
                                      child: const Text('Sim, estive lá'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 32),

                      // SEÇÃO DE PARTICIPANTES (Fiel aos mockups)
                      Text(
                        event.status == EventStatus.completed
                            ? 'Quem esteve presente (${event.confirmedCount})'
                            : (event.status == EventStatus.full
                                  ? 'Participantes confirmados (${event.confirmedCount})'
                                  : 'Quem já confirmou (${event.confirmedCount})'),
                        style: ConvivaTypography.titleSerifMedium,
                      ),
                      const SizedBox(height: 16),

                      // Lista de Participantes (02, 03, 04 PNGs)
                      ...event.participants.map(
                        (p) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildParticipantTile(event.id, p),
                        ),
                      ),

                      // Opção de Carona para o evento (Se for futuro e estiver participando)
                      if (event.status == EventStatus.upcoming &&
                          event.isUserParticipating) ...[
                        const SizedBox(height: 24),
                        _buildTransportPromptCard(event),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFEFE8D8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: ConvivaColors.textPrimary, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: ConvivaColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildParticipantTile(String eventId, EventParticipant participant) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ConvivaColors.border, width: 1.1),
      ),
      child: Row(
        children: [
          // Avatar Circular com Iniciais em Serif (ex: JR, AC, EM)
          CircleAvatar(
            radius: 22,
            backgroundColor: ConvivaColors.avatarBg,
            child: Text(
              participant.initials,
              style: const TextStyle(
                fontFamily: 'serif',
                fontSize: 16,
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
                  participant.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ConvivaColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  participant.timeAgo,
                  style: const TextStyle(
                    fontSize: 13,
                    color: ConvivaColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Botão Adicionar Amigo / Conexão (03-evento-lotado.png)
          InkWell(
            onTap: () {
              ConvivaState.instance.toggleParticipantFriend(
                eventId,
                participant.id,
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: participant.isFriend
                    ? ConvivaColors.pineGreenLight
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: participant.isFriend
                      ? ConvivaColors.pineGreen
                      : ConvivaColors.border,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    participant.isFriend ? Icons.check : Icons.person_add_alt_1,
                    size: 16,
                    color: participant.isFriend
                        ? ConvivaColors.pineGreenText
                        : ConvivaColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    participant.isFriend ? 'Adicionado' : 'Adicionar',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: participant.isFriend
                          ? ConvivaColors.pineGreenText
                          : ConvivaColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransportPromptCard(ConvivaEvent event) {
    final state = ConvivaState.instance;
    final existingRide = state.getRideForEvent(event.id);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ConvivaColors.pineGreen.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.directions_car_filled_rounded,
                color: ConvivaColors.pineGreen,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'Mobilidade & Carona Solidária',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ConvivaColors.pineGreenText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Você gostaria de ser buscado em casa para este evento?',
            style: TextStyle(fontSize: 14, color: ConvivaColors.textSecondary),
          ),
          const SizedBox(height: 14),
          if (existingRide == null) ...[
            ElevatedButton.icon(
              onPressed: () {
                _showRequestRideDialog(context, event);
              },
              icon: const Icon(Icons.hail_rounded),
              label: const Text('Preciso de transporte'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ConvivaColors.pineGreen,
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ConvivaColors.pineGreenLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: ConvivaColors.pineGreen,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Status: ${existingRide.statusLabel}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ConvivaColors.pineGreenText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showRequestRideDialog(BuildContext context, ConvivaEvent event) {
    final state = ConvivaState.instance;
    final user = state.currentUser;
    final addressCtrl = TextEditingController(
      text: user?.address ?? 'Rua das Camélias, 120 - Jardim das Flores',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Solicitar Carona Solidária',
          style: ConvivaTypography.titleSerifMedium,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Um motorista voluntário do CONVIVA buscará você no endereço abaixo:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: addressCtrl,
              decoration: const InputDecoration(
                labelText: 'Endereço de partida',
                prefixIcon: Icon(Icons.home_outlined),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Destino: ${event.location}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: ConvivaColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              state.requestRide(
                eventId: event.id,
                eventTitle: event.title,
                destinationAddress: event.location,
                pickupAddress: addressCtrl.text.trim(),
                scheduledTime: '13:30',
              );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Transporte solicitado! Os motoristas parceiros já receberam sua solicitação.',
                  ),
                  backgroundColor: ConvivaColors.pineGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ConvivaColors.pineGreen,
              minimumSize: const Size(120, 48),
            ),
            child: const Text('Confirmar Solicitação'),
          ),
        ],
      ),
    );
  }
}

// 7. MEUS EVENTOS DO IDOSO
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
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Transporte solicitado para este evento!',
                                          ),
                                          backgroundColor:
                                              ConvivaColors.pineGreen,
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
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

// 8. TELA DE TRANSPORTE DO USUÁRIO
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
              // Banner informativo sobre o transporte solidário
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

// ============================================================================
// 7. MÓDULO DO ORGANIZADOR (SHELL, DASHBOARD, CRIAR EVENTO, MEUS EVENTOS, LISTA DE PRESENÇA)
// ============================================================================

class OrganizerMainShell extends StatefulWidget {
  const OrganizerMainShell({super.key});

  @override
  State<OrganizerMainShell> createState() => _OrganizerMainShellState();
}

class _OrganizerMainShellState extends State<OrganizerMainShell> {
  int _currentIndex = 0;

  final _pages = const [
    OrganizerDashboardScreen(),
    OrganizerEventsScreen(),
    CreateEventScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        backgroundColor: ConvivaColors.background,
        indicatorColor: ConvivaColors.pineGreenLight,
        elevation: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(
              Icons.dashboard_rounded,
              color: ConvivaColors.pineGreen,
            ),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(
              Icons.event_note_rounded,
              color: ConvivaColors.pineGreen,
            ),
            label: 'Meus Eventos',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline_rounded),
            selectedIcon: Icon(
              Icons.add_circle_rounded,
              color: ConvivaColors.pineGreen,
            ),
            label: 'Criar Evento',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(
              Icons.person_rounded,
              color: ConvivaColors.pineGreen,
            ),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

// 9. DASHBOARD DO ORGANIZADOR
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

// 10. CRIAÇÃO DE EVENTO PELO ORGANIZADOR
class CreateEventScreen extends StatefulWidget {
  final ConvivaEvent? eventToEdit;

  const CreateEventScreen({super.key, this.eventToEdit});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _dateCtrl;
  late TextEditingController _locationCtrl;
  late TextEditingController _categoryCtrl;
  late TextEditingController _maxSpotsCtrl;

  @override
  void initState() {
    super.initState();
    final ev = widget.eventToEdit;
    _titleCtrl = TextEditingController(
      text: ev?.title ?? 'Chá das Quatro e Roda de Conversa',
    );
    _descCtrl = TextEditingController(
      text: ev?.description ??
          'Um momento acolhedor para compartilhar histórias, saborear chás artesanais e fazer novas amizades na nossa comunidade.',
    );
    _dateCtrl = TextEditingController(
      text: ev?.dateFormatted ?? 'Terça, 24 de setembro · 15h00',
    );
    _locationCtrl = TextEditingController(
      text: ev?.location ?? 'Centro Cultural Comunitário - Sala 2',
    );
    _categoryCtrl = TextEditingController(
      text: ev?.category ?? 'Convivência & Café',
    );
    _maxSpotsCtrl = TextEditingController(
      text: ev?.maxSpots.toString() ?? '25',
    );
  }

  void _saveEvent() {
    if (_formKey.currentState!.validate()) {
      final state = ConvivaState.instance;
      final max = int.tryParse(_maxSpotsCtrl.text) ?? 30;

      if (widget.eventToEdit != null) {
        final updated = widget.eventToEdit!;
        updated.title = _titleCtrl.text.trim();
        updated.description = _descCtrl.text.trim();
        updated.dateFormatted = _dateCtrl.text.trim();
        updated.location = _locationCtrl.text.trim();
        updated.category = _categoryCtrl.text.trim();
        updated.maxSpots = max;
        state.updateEvent(updated);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Evento atualizado com sucesso!')),
        );
      } else {
        final newEvent = ConvivaEvent(
          id: 'ev_${DateTime.now().millisecondsSinceEpoch}',
          title: _titleCtrl.text.trim(),
          dateFormatted: _dateCtrl.text.trim(),
          location: _locationCtrl.text.trim(),
          distance: '0,8 km de você',
          category: _categoryCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          status: EventStatus.upcoming,
          confirmedCount: 1,
          maxSpots: max,
          organizerId: state.currentUser?.id ?? 'org_carlos',
          participants: [
            EventParticipant(
              id: 'p_demo',
              name: 'Dona Marta',
              initials: 'DM',
              timeAgo: 'Confirmou hoje',
              phone: '(11) 98765-4321',
              isPresent: true,
            ),
          ],
        );
        state.addEvent(newEvent);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Evento criado com sucesso! Já está visível para os idosos.',
            ),
            backgroundColor: ConvivaColors.pineGreen,
          ),
        );
      }

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.eventToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Evento' : 'Criar Novo Evento'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleCtrl,
                style: const TextStyle(fontSize: 17),
                decoration: const InputDecoration(
                  labelText: 'Nome do evento',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (v) =>
                    v!.isEmpty ? 'Informe o nome do evento' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryCtrl,
                style: const TextStyle(fontSize: 17),
                decoration: const InputDecoration(
                  labelText:
                      'Categoria (ex: Artesanato, Dança, Jogos, Caminhada)',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                validator: (v) => v!.isEmpty ? 'Informe a categoria' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateCtrl,
                style: const TextStyle(fontSize: 17),
                decoration: const InputDecoration(
                  labelText: 'Data e Horário (ex: Sábado, 14 de setembro · 14h)',
                  prefixIcon: Icon(Icons.event_outlined),
                ),
                validator: (v) => v!.isEmpty ? 'Informe data e horário' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationCtrl,
                style: const TextStyle(fontSize: 17),
                decoration: const InputDecoration(
                  labelText: 'Endereço completo / Local',
                  prefixIcon: Icon(Icons.place_outlined),
                ),
                validator: (v) => v!.isEmpty ? 'Informe o local' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _maxSpotsCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 17),
                decoration: const InputDecoration(
                  labelText: 'Número máximo de vagas (opcional)',
                  prefixIcon: Icon(Icons.people_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descCtrl,
                maxLines: 4,
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                  labelText: 'Descrição acolhedora do evento',
                  alignLabelWithHint: true,
                ),
                validator: (v) => v!.isEmpty ? 'Descreva o evento' : null,
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: _saveEvent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ConvivaColors.pineGreen,
                ),
                child: Text(isEditing ? 'Salvar Alterações' : 'Criar Evento'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 11. EVENTOS DO ORGANIZADOR COM BOTÕES DE EDITAR, EXCLUIR E LISTA DE PRESENÇA
class OrganizerEventsScreen extends StatelessWidget {
  const OrganizerEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = ConvivaState.instance;

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final events = state.events;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Eventos que Organizo'),
            automaticallyImplyLeading: false,
          ),
          body: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: events.length,
            itemBuilder: (ctx, idx) {
              final event = events[idx];
              return Container(
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
                            color: event.statusBadgeBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            event.statusBadgeLabel,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: event.statusBadgeTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${event.dateFormatted} • ${event.location}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: ConvivaColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Participantes: ${event.confirmedCount} confirmados',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: ConvivaColors.pineGreen,
                      ),
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
                                  builder: (_) =>
                                      CreateEventScreen(eventToEdit: event),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(0, 42),
                            ),
                            child: const Text('Editar'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              _confirmDelete(context, event);
                            },
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(0, 42),
                              foregroundColor: ConvivaColors.terracotta,
                            ),
                            child: const Text('Excluir'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AttendanceListScreen(event: event),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(0, 42),
                              backgroundColor: ConvivaColors.pineGreen,
                            ),
                            child: const Text(
                              'Presença',
                              style: TextStyle(fontSize: 14),
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

  void _confirmDelete(BuildContext context, ConvivaEvent event) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir evento?'),
        content: Text('Tem certeza que deseja excluir "${event.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              ConvivaState.instance.deleteEvent(event.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Evento removido com sucesso.')),
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
}

// 12. LISTA DE PRESENÇA DO ORGANIZADOR
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
                      // Checkbox interativo de Presença ✓ / ○
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

// ============================================================================
// 8. MÓDULO DO MOTORISTA (SHELL, MINHAS CORRIDAS, ROTA GPS SIMULADA)
// ============================================================================

class DriverMainShell extends StatefulWidget {
  const DriverMainShell({super.key});

  @override
  State<DriverMainShell> createState() => _DriverMainShellState();
}

class _DriverMainShellState extends State<DriverMainShell> {
  int _currentIndex = 0;

  final _pages = const [
    DriverRidesScreen(),
    DriverRouteScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        backgroundColor: ConvivaColors.background,
        indicatorColor: ConvivaColors.pineGreenLight,
        elevation: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.local_taxi_outlined),
            selectedIcon: Icon(
              Icons.local_taxi_rounded,
              color: ConvivaColors.pineGreen,
            ),
            label: 'Minhas Corridas',
          ),
          NavigationDestination(
            icon: Icon(Icons.alt_route_rounded),
            selectedIcon: Icon(
              Icons.route_rounded,
              color: ConvivaColors.pineGreen,
            ),
            label: 'Rotas / GPS',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(
              Icons.person_rounded,
              color: ConvivaColors.pineGreen,
            ),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

// 13. PAINEL DO MOTORISTA - MINHAS CORRIDAS
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

// 14. TELA DE ROTA / GPS SIMULADA E INTERATIVA
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
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
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
    // Ruas de fundo
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final roadBorderPaint = Paint()
      ..color = const Color(0xFFD4DEC4)
      ..strokeWidth = 18
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Caminho da rua
    final roadPath = Path();
    roadPath.moveTo(60, 40);
    roadPath.lineTo(100, 160);
    roadPath.lineTo(size.width * 0.45, 180);
    roadPath.lineTo(size.width * 0.65, size.height * 0.55);
    roadPath.lineTo(size.width - 70, size.height - 80);

    canvas.drawPath(roadPath, roadBorderPaint);
    canvas.drawPath(roadPath, roadPaint);

    // Linha de navegação GPS (Azul / Verde Pinheiro)
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

// ============================================================================
// 9. TELA DE PERFIL E ALTERNADOR RÁPIDO DE PAPEL (PARA HACKATHON)
// ============================================================================

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = ConvivaState.instance;

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final user = state.currentUser;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Meu Perfil'),
            automaticallyImplyLeading: false,
          ),
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // Card de Usuário
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: ConvivaColors.pineGreenLight,
                      child: Text(
                        user?.initials ?? 'CO',
                        style: const TextStyle(
                          fontFamily: 'serif',
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: ConvivaColors.pineGreen,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user?.name ?? 'Usuário CONVIVA',
                      style: ConvivaTypography.titleSerifMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? '',
                      style: const TextStyle(
                        fontSize: 15,
                        color: ConvivaColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: ConvivaColors.pineGreenLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _getRoleName(user?.role),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: ConvivaColors.pineGreenText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // SELETOR RÁPIDO DE PERFIL (FUNDAMENTAL PARA APRESENTAÇÃO DE HACKATHON)
              Container(
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
                      children: const [
                        Icon(
                          Icons.swap_horiz_rounded,
                          color: ConvivaColors.pineGreen,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Alternar Perfil para Demonstração',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ConvivaColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Troque instantaneamente entre os 3 perfis do aplicativo:',
                      style: TextStyle(
                        fontSize: 13,
                        color: ConvivaColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _buildRoleButton(
                            context,
                            label: '👵 Idosa',
                            role: UserRole.senior,
                            isSelected: user?.role == UserRole.senior,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildRoleButton(
                            context,
                            label: '📋 Organizador',
                            role: UserRole.organizer,
                            isSelected: user?.role == UserRole.organizer,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildRoleButton(
                            context,
                            label: '🚗 Motorista',
                            role: UserRole.driver,
                            isSelected: user?.role == UserRole.driver,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Informações do Projeto
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: ConvivaColors.border, width: 1.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Sobre o CONVIVA',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Plataforma inclusiva com acessibilidade para pessoas idosas, focada no combate à solidão, fomento a atividades comunitárias e facilitação de transporte solidário.',
                      style: TextStyle(
                        fontSize: 14,
                        color: ConvivaColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Botão Sair da Conta
              OutlinedButton.icon(
                onPressed: () {
                  state.logout();
                },
                icon: const Icon(
                  Icons.logout_rounded,
                  color: ConvivaColors.terracotta,
                ),
                label: const Text(
                  'Sair da Conta',
                  style: TextStyle(
                    color: ConvivaColors.terracotta,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRoleButton(
    BuildContext context, {
    required String label,
    required UserRole role,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        ConvivaState.instance.switchRole(role);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Alternado para o perfil: ${_getRoleName(role)}'),
            backgroundColor: ConvivaColors.pineGreen,
            duration: const Duration(seconds: 1),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color:
              isSelected ? ConvivaColors.pineGreen : ConvivaColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? ConvivaColors.pineGreen : ConvivaColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : ConvivaColors.textPrimary,
          ),
        ),
      ),
    );
  }

  String _getRoleName(UserRole? role) {
    switch (role) {
      case UserRole.senior:
        return 'Usuário / Idoso';
      case UserRole.organizer:
        return 'Organizador de Eventos';
      case UserRole.driver:
        return 'Motorista Parceiro Solidário';
      default:
        return 'Visitante';
    }
  }
}
