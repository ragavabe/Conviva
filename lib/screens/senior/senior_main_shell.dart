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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(top: BorderSide(color: ConvivaColors.border, width: 1.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
          backgroundColor: Colors.white,
          indicatorColor: ConvivaColors.pineGreenLight,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          height: 72,
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
                size: 30,
                color: ConvivaColors.pineGreen,
              ),
              label: 'Início',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.calendar_today_outlined,
                size: 26,
                color: ConvivaColors.textSecondary,
              ),
              selectedIcon: Icon(
                Icons.calendar_month_rounded,
                size: 28,
                color: ConvivaColors.pineGreen,
              ),
              label: 'Minha Agenda',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.directions_car_outlined,
                size: 28,
                color: ConvivaColors.textSecondary,
              ),
              selectedIcon: Icon(
                Icons.directions_car_filled_rounded,
                size: 30,
                color: ConvivaColors.pineGreen,
              ),
              label: 'Caronas',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.person_outline_rounded,
                size: 28,
                color: ConvivaColors.textSecondary,
              ),
              selectedIcon: Icon(
                Icons.person_rounded,
                size: 30,
                color: ConvivaColors.pineGreen,
              ),
              label: 'Meu Perfil',
            ),
          ],
        ),
      ),
    );
  }
}
