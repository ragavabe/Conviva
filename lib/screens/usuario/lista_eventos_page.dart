import 'package:flutter/material.dart';
import '../../core/state/app_state.dart';
import '../../models/tipo_usuario.dart';
import '../../widgets/header_gradiente.dart';
import '../../widgets/icone_circular.dart';
import 'card_evento_usuario.dart';

class ListaEventosPage extends StatelessWidget {
  const ListaEventosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (context, _) {
        final user = AppState.instance.usuarioLogado;
        if (user == null) return const SizedBox.shrink();
        final eventos = AppState.instance.eventos;
        final primeiroNome = user.nome.split(' ').first;

        return Scaffold(
          body: Column(
            children: [
              HeaderGradiente(
                titulo: 'Olá, $primeiroNome!',
                subtitulo: '${eventos.length} eventos disponíveis',
                icone: Icons.celebration_rounded,
                cores: user.tipo.gradiente,
                altura: 200,
                trailing: IconeCircular(
                  icone: Icons.logout_rounded,
                  onTap: () => AppState.instance.logout(),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
                  itemCount: eventos.length,
                  itemBuilder: (_, i) =>
                      CardEventoUsuario(evento: eventos[i], index: i),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
