import 'package:flutter/material.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/header_gradiente.dart';
import '../../widgets/icone_circular.dart';

class MotoristaEmBrevePage extends StatelessWidget {
  const MotoristaEmBrevePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderGradiente(
            titulo: 'Área do Motorista',
            subtitulo: 'Em desenvolvimento',
            icone: Icons.directions_bus_rounded,
            cores: const [AppColors.verde, AppColors.verdeEscuro],
            altura: 220,
            trailing: IconeCircular(
              icone: Icons.logout_rounded,
              onTap: () => AppState.instance.logout(),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: AppColors.verde.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.construction_rounded,
                        size: 64,
                        color: AppColors.verde,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Em breve!',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.texto,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'A área do motorista ainda está sendo\npreparada com muito carinho. 🚌💨',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textoSecundario,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
