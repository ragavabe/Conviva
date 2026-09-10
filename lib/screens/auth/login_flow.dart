import 'package:flutter/material.dart';
import '../../models/tipo_usuario.dart';
import 'escolha_tipo_page.dart';
import 'formulario_page.dart';

class LoginFlow extends StatefulWidget {
  const LoginFlow({super.key});

  @override
  State<LoginFlow> createState() => _LoginFlowState();
}

class _LoginFlowState extends State<LoginFlow> {
  TipoUsuario? _tipoEscolhido;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, anim) {
          final slide = Tween<Offset>(
            begin: const Offset(0.12, 0),
            end: Offset.zero,
          ).animate(anim);
          return FadeTransition(
            opacity: anim,
            child: SlideTransition(position: slide, child: child),
          );
        },
        child: _tipoEscolhido == null
            ? EscolhaTipoPage(
                key: const ValueKey('escolha'),
                onEscolher: (t) => setState(() => _tipoEscolhido = t),
              )
            : FormularioPage(
                key: ValueKey('form_${_tipoEscolhido!.name}'),
                tipo: _tipoEscolhido!,
                onVoltar: () => setState(() => _tipoEscolhido = null),
              ),
      ),
    );
  }
}
