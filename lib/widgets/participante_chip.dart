import 'package:flutter/material.dart';
import 'package:characters/characters.dart';

import '../core/theme/app_colors.dart';

class ParticipanteChip extends StatelessWidget {
  final String nome;
  final bool podeFacebook;
  final bool ehUsuarioAtual;

  const ParticipanteChip({
    super.key,
    required this.nome,
    required this.podeFacebook,
    this.ehUsuarioAtual = false,
  });

  String get _iniciais {
    final partes = nome
        .trim()
        .split(RegExp(r'\s+'))
        .where((parte) => parte.isNotEmpty);
    if (partes.isEmpty) return '?';
    return partes
        .take(2)
        .map((parte) => parte.characters.first)
        .join()
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 4, 10, 4),
      decoration: BoxDecoration(
        color: ehUsuarioAtual
            ? AppColors.roxo.withValues(alpha: 0.12)
            : AppColors.fundo,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: ehUsuarioAtual
              ? AppColors.roxo
              : AppColors.roxoClaro.withValues(alpha: 0.4),
          width: ehUsuarioAtual ? 1.5 : 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: ehUsuarioAtual
                ? AppColors.roxoEscuro
                : AppColors.roxo,
            child: Text(
              _iniciais,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              nome.trim().isEmpty ? 'Participante' : nome.trim(),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.texto,
              ),
            ),
          ),
          if (ehUsuarioAtual) ...[
            const SizedBox(width: 6),
            const Text(
              'Você',
              style: TextStyle(
                color: AppColors.roxoEscuro,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
          if (podeFacebook) ...[
            const SizedBox(width: 8),
            Tooltip(
              message: 'Conectar no Facebook',
              child: InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      content: Text('Abrindo Facebook de $nome...'),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1877F2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.facebook,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
