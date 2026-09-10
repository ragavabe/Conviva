import 'package:flutter/material.dart';
import 'core/colors.dart';
import 'core/typography.dart';
import 'core/state.dart';
import 'models/app_user.dart';
import 'screens/auth/login_screen.dart';
import 'screens/senior/senior_main_shell.dart';
import 'screens/organizer/organizer_main_shell.dart';
import 'screens/driver/driver_main_shell.dart';

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
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(ConvivaState.instance.textScaleFactor),
              ),
              child: child!,
            );
          },
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
