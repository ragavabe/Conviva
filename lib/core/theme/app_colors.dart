import 'package:flutter/material.dart';

class AppColors {
  static const roxo = Color(0xFF6C4AB6);
  static const roxoEscuro = Color(0xFF4A2F85);
  static const roxoClaro = Color(0xFFB39DDB);
  static const verde = Color(0xFF00897B);
  static const verdeEscuro = Color(0xFF00695C);
  static const laranja = Color(0xFFEF6C00);
  static const laranjaEscuro = Color(0xFFE65100);
  static const fundo = Color(0xFFF5F3FB);
  static const card = Colors.white;
  static const texto = Color(0xFF2D2A3E);
  static const textoSecundario = Color(0xFF6E6A80);
  static const sucesso = Color(0xFF2E7D32);
  static const alerta = Color(0xFFF9A825);
  static const cinza = Color(0xFF9E9E9E);
}

class AppShadows {
  static final suave = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];
  static final media = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.10),
      blurRadius: 22,
      offset: const Offset(0, 10),
    ),
  ];
  static List<BoxShadow> colorida(Color c) => [
    BoxShadow(
      color: c.withValues(alpha: 0.30),
      blurRadius: 18,
      offset: const Offset(0, 8),
    ),
  ];
}
