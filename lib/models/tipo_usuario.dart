import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

enum TipoUsuario { organizador, motorista, usuario }

extension TipoUsuarioInfo on TipoUsuario {
  String get label => switch (this) {
    TipoUsuario.organizador => 'Organizador',
    TipoUsuario.motorista => 'Motorista',
    TipoUsuario.usuario => 'Usuário',
  };

  String get descricao => switch (this) {
    TipoUsuario.organizador => 'Crie e gerencie eventos',
    TipoUsuario.motorista => 'Leve pessoas aos eventos',
    TipoUsuario.usuario => 'Participe de eventos sociais',
  };

  IconData get icone => switch (this) {
    TipoUsuario.organizador => Icons.event_available_rounded,
    TipoUsuario.motorista => Icons.directions_bus_rounded,
    TipoUsuario.usuario => Icons.emoji_people_rounded,
  };

  Color get cor => switch (this) {
    TipoUsuario.organizador => AppColors.roxo,
    TipoUsuario.motorista => AppColors.verde,
    TipoUsuario.usuario => AppColors.laranja,
  };

  List<Color> get gradiente => switch (this) {
    TipoUsuario.organizador => [AppColors.roxo, AppColors.roxoEscuro],
    TipoUsuario.motorista => [AppColors.verde, AppColors.verdeEscuro],
    TipoUsuario.usuario => [AppColors.laranja, AppColors.laranjaEscuro],
  };
}
