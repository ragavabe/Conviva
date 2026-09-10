import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../shared/profile_screen.dart';
import 'organizer_dashboard_screen.dart';
import 'organizer_events_screen.dart';
import 'create_event_screen.dart';

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
