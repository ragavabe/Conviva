import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../shared/profile_screen.dart';
import 'senior_home_screen.dart';
import 'senior_my_events_screen.dart';
import 'senior_transport_screen.dart';

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
