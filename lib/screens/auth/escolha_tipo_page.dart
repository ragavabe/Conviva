import 'package:flutter/material.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/facebook_auth_service.dart';
import '../../models/tipo_usuario.dart';
import '../../widgets/header_gradiente.dart';
import 'cartao_tipo_animado.dart';

class EscolhaTipoPage extends StatefulWidget {
  final void Function(TipoUsuario) onEscolher;

  const EscolhaTipoPage({super.key, required this.onEscolher});

  @override
  State<EscolhaTipoPage> createState() => _EscolhaTipoPageState();
}

class _EscolhaTipoPageState extends State<EscolhaTipoPage> {
  bool _isFacebookLoading = false;

  Future<void> _handleFacebookLogin() async {
    // Deixa a pessoa escolher o tipo de perfil antes de logar com Facebook
    final tipoEscolhido = await showModalBottomSheet<TipoUsuario>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.textoSecundario.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Entrar com Facebook',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            const Text(
              'Escolha com qual perfil você quer acessar:',
              style: TextStyle(fontSize: 14, color: AppColors.textoSecundario),
            ),
            const SizedBox(height: 18),
            for (final tipo in TipoUsuario.values)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: tipo.cor.withValues(alpha: 0.15),
                    child: Icon(tipo.icone, color: tipo.cor),
                  ),
                  title: Text(
                    tipo.label,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(tipo.descricao),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: tipo.cor.withValues(alpha: 0.3)),
                  ),
                  onTap: () => Navigator.pop(ctx, tipo),
                ),
              ),
          ],
        ),
      ),
    );

    if (tipoEscolhido == null || !mounted) return;

    setState(() => _isFacebookLoading = true);
    try {
      final result = await FacebookAuthService.instance.login(
        tipo: tipoEscolhido,
      );

      if (!mounted) return;

      if (result.isSuccess && result.pessoa != null) {
        AppState.instance.login(result.pessoa!);
        // AppState notifica o RootGate, que troca de tela automaticamente.
      } else if (result.isCancelled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login com Facebook cancelado.')),
        );
      } else if (result.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isFacebookLoading = false);
      }
    }
  }

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
                      onTap: () => widget.onEscolher(TipoUsuario.values[i]),
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: AppColors.textoSecundario.withValues(alpha: 0.3),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'ou',
                        style: TextStyle(color: AppColors.textoSecundario),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: AppColors.textoSecundario.withValues(alpha: 0.3),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _isFacebookLoading ? null : _handleFacebookLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1877F2),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: _isFacebookLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.facebook, size: 22),
                    label: Text(
                      _isFacebookLoading
                          ? 'Conectando ao Facebook...'
                          : 'Continuar com Facebook',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
