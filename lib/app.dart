import 'package:conviva/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';

import 'core/state/app_state.dart';
import 'core/theme/app_theme.dart';
import 'models/tipo_usuario.dart';
import 'screens/motorista/motorista_em_breve_page.dart';
import 'screens/organizador/organizador_dashboard.dart';
import 'screens/usuario/lista_eventos_page.dart';

class EventosIdososApp extends StatelessWidget {
  const EventosIdososApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eventos para Idosos',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const RootGate(),
    );
  }
}

/// Alias para manter compatibilidade com ConvivaApp
typedef ConvivaApp = EventosIdososApp;

class RootGate extends StatelessWidget {
  const RootGate({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (context, _) {
        final user = AppState.instance.usuarioLogado;
        if (user == null) return const LoginScreen();
        if (user.tipo == TipoUsuario.organizador) {
          return const OrganizadorDashboard();
        }
        if (user.tipo == TipoUsuario.motorista) {
          return const MotoristaEmBrevePage();
        }
        return const ListaEventosPage();
      },
    );
  }
}
