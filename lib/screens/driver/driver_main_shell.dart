import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../shared/profile_screen.dart';
import 'driver_rides_screen.dart';
import 'driver_route_screen.dart';

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
