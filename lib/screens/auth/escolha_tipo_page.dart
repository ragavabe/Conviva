import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/tipo_usuario.dart';
import '../../widgets/header_gradiente.dart';
import 'cartao_tipo_animado.dart';

class EscolhaTipoPage extends StatelessWidget {
  final void Function(TipoUsuario) onEscolher;

  const EscolhaTipoPage({
    super.key,
    required this.onEscolher,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        children: [
          const HeaderGradiente(
            titulo: 'Eventos para Idosos',
            subtitulo: 'Conecte-se, participe, viva!',
            icone: Icons.emoji_people_rounded,
            cores: [AppColors.roxo, AppColors.roxoEscuro],
            altura: 240,
          ),
          const SizedBox(height: 28),
          const Text(
            'Quem é você?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.texto,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Escolha uma opção para continuar',
            style: TextStyle(fontSize: 15, color: AppColors.textoSecundario),
          ),
          const SizedBox(height: 22),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                for (var i = 0; i < TipoUsuario.values.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: CartaoTipoAnimado(
                      tipo: TipoUsuario.values[i],
                      delay: i * 90,
                      onTap: () => onEscolher(TipoUsuario.values[i]),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
