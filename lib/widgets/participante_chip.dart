import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class ParticipanteChip extends StatelessWidget {
  final String nome;
  final bool podeFacebook;

  const ParticipanteChip({
    super.key,
    required this.nome,
    required this.podeFacebook,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 4, 10, 4),
      decoration: BoxDecoration(
        color: AppColors.fundo,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.roxoClaro.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: AppColors.roxo,
            child: Text(
              nome.substring(0, 1).toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            nome,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: AppColors.texto,
            ),
          ),
          if (podeFacebook) ...[
            const SizedBox(width: 8),
            GestureDetector(
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
          ],
        ],
      ),
    );
  }
}
