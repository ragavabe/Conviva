import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'icone_circular.dart';

/// Cabeçalho com gradiente arredondado embaixo.
/// O botão de voltar (opcional) fica à ESQUERDA, junto ao título.
class HeaderGradiente extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final IconData icone;
  final List<Color> cores;
  final double altura;
  final VoidCallback? onVoltar;
  final Widget? trailing;

  const HeaderGradiente({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.icone,
    required this.cores,
    this.altura = 220,
    this.onVoltar,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: altura,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: cores,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(34),
          bottomRight: Radius.circular(34),
        ),
        boxShadow: AppShadows.colorida(cores.first),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Linha do topo: voltar (esquerda) + trailing (direita) ---
              Row(
                children: [
                  if (onVoltar != null)
                    IconeCircular(
                      icone: Icons.arrow_back_rounded,
                      onTap: onVoltar!,
                    )
                  else
                    const SizedBox(width: 48),
                  const Spacer(),
                  ?trailing,
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(icone, color: Colors.white, size: 34),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      titulo,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitulo,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
