import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class EstadoVazio extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String sub;

  const EstadoVazio({
    super.key,
    required this.icone,
    required this.titulo,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                color: AppColors.roxoClaro.withValues(alpha: 0.25),
                shape: BoxShape.circle,
              ),
              child: Icon(icone, size: 56, color: AppColors.roxo),
            ),
            const SizedBox(height: 20),
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.texto,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              sub,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textoSecundario,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
