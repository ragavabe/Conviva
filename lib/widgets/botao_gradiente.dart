import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Botão grande e arredondado com gradiente.
class BotaoGradiente extends StatelessWidget {
  final String texto;
  final IconData icone;
  final VoidCallback? onPressed;
  final List<Color> cores;
  final bool expandido;

  const BotaoGradiente({
    super.key,
    required this.texto,
    required this.icone,
    required this.onPressed,
    required this.cores,
    this.expandido = true,
  });

  @override
  Widget build(BuildContext context) {
    final desabilitado = onPressed == null;
    final c = desabilitado ? [AppColors.cinza, AppColors.cinza] : cores;

    return Container(
      width: expandido ? double.infinity : null,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: c),
        borderRadius: BorderRadius.circular(18),
        boxShadow: desabilitado ? [] : AppShadows.colorida(c.first),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(18),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icone, color: Colors.white, size: 22),
                const SizedBox(width: 10),
                Text(
                  texto,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
