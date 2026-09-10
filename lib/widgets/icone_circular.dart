import 'package:flutter/material.dart';

/// Botão circular translúcido (usado no voltar e no logout).
class IconeCircular extends StatelessWidget {
  final IconData icone;
  final VoidCallback onTap;

  const IconeCircular({
    super.key,
    required this.icone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icone, color: Colors.white),
        onPressed: onTap,
      ),
    );
  }
}
