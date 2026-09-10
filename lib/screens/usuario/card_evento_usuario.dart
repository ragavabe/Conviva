import 'package:flutter/material.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../models/evento.dart';
import '../../widgets/botao_gradiente.dart';
import '../../widgets/chip_status.dart';
import '../../widgets/participante_chip.dart';

class CardEventoUsuario extends StatefulWidget {
  final Evento evento;
  final int index;

  const CardEventoUsuario({
    super.key,
    required this.evento,
    required this.index,
  });

  @override
  State<CardEventoUsuario> createState() => _CardEventoUsuarioState();
}

class _CardEventoUsuarioState extends State<CardEventoUsuario>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fade = CurvedAnimation(parent: _c, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _c, curve: Curves.easeOutCubic));
    Future.delayed(Duration(milliseconds: widget.index * 80), () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.evento;
    final user = AppState.instance.usuarioLogado!;
    final jaParticipa = e.participantes.contains(user.nome);

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          margin: const EdgeInsets.only(bottom: 18),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(24),
            boxShadow: AppShadows.media,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: _corStatusGradiente(e)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              e.titulo,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppColors.texto,
                                height: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildStatusChip(e),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        e.descricao,
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.textoSecundario,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _infoPill(
                        Icons.calendar_today_rounded,
                        '${e.data}  •  ${e.horario}',
                      ),
                      const SizedBox(height: 6),
                      _infoPill(Icons.location_on_rounded, e.local),
                      const SizedBox(height: 6),
                      _infoPill(
                        Icons.people_alt_rounded,
                        '${e.participantes.length} de ${e.capacidade} confirmados',
                      ),
                      if (!e.realizado && !e.lotado) ...[
                        const SizedBox(height: 6),
                        _infoPill(
                          Icons.confirmation_number_rounded,
                          '${e.vagasRestantes} vagas restantes',
                          cor: AppColors.sucesso,
                        ),
                      ],
                      const SizedBox(height: 16),
                      if (e.participantes.isNotEmpty) ...[
                        Row(
                          children: [
                            const Icon(
                              Icons.groups_rounded,
                              size: 18,
                              color: AppColors.roxo,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              e.realizado
                                  ? 'Quem esteve presente'
                                  : 'Quem vai participar',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: AppColors.texto,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: e.participantes
                              .map(
                                (p) => ParticipanteChip(
                                  nome: p,
                                  podeFacebook: e.realizado || e.lotado,
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                      ],
                      SizedBox(
                        width: double.infinity,
                        child: _buildBotaoAcao(context, e, jaParticipa),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Color> _corStatusGradiente(Evento e) {
    if (e.realizado) return [AppColors.cinza, const Color(0xFF616161)];
    if (e.lotado) return [AppColors.alerta, const Color(0xFFEF6C00)];
    return [const Color(0xFF43A047), const Color(0xFF2E7D32)];
  }

  Widget _buildStatusChip(Evento e) {
    if (e.realizado) {
      return const ChipStatus(
        label: 'Realizado',
        cor: AppColors.cinza,
        icone: Icons.history_rounded,
      );
    }
    if (e.lotado) {
      return const ChipStatus(
        label: 'Completo',
        cor: AppColors.alerta,
        icone: Icons.lock_rounded,
      );
    }
    return const ChipStatus(
      label: 'Aberto',
      cor: AppColors.sucesso,
      icone: Icons.check_rounded,
    );
  }

  Widget _infoPill(IconData icon, String text, {Color? cor}) {
    final c = cor ?? AppColors.textoSecundario;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: c.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 14, color: c),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: c == AppColors.textoSecundario ? AppColors.texto : c,
              fontWeight: c == AppColors.textoSecundario
                  ? FontWeight.w500
                  : FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBotaoAcao(BuildContext context, Evento e, bool jaParticipa) {
    if (jaParticipa) {
      return Container(
        height: 54,
        decoration: BoxDecoration(
          color: AppColors.sucesso.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.sucesso.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        child: const Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: AppColors.sucesso,
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                'Você já confirmou presença',
                style: TextStyle(
                  color: AppColors.sucesso,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (e.realizado) {
      return BotaoGradiente(
        texto: 'Confirmar que estive presente',
        icone: Icons.how_to_reg_rounded,
        cores: const [Color(0xFF757575), Color(0xFF424242)],
        onPressed: () => _confirmarPresencaRealizado(context),
      );
    }
    if (e.lotado) {
      return BotaoGradiente(
        texto: 'Evento completo',
        icone: Icons.lock_rounded,
        cores: const [AppColors.cinza, AppColors.cinza],
        onPressed: null,
      );
    }
    return BotaoGradiente(
      texto: 'Participar',
      icone: Icons.add_task_rounded,
      cores: const [AppColors.roxo, AppColors.roxoEscuro],
      onPressed: () => _participar(context),
    );
  }

  void _participar(BuildContext context) {
    final ok = AppState.instance.participar(widget.evento);
    _showSnack(
      context,
      ok ? 'Presença confirmada! 🎉' : 'Não foi possível confirmar.',
      ok ? AppColors.sucesso : Colors.red,
    );
  }

  void _confirmarPresencaRealizado(BuildContext context) {
    final ok = AppState.instance.confirmarPresencaRealizado(widget.evento);
    _showSnack(
      context,
      ok ? 'Presença confirmada no evento! ✅' : 'Você já está na lista.',
      ok ? AppColors.sucesso : Colors.orange,
    );
  }

  void _showSnack(BuildContext context, String msg, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: cor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Row(
          children: [
            const Icon(Icons.info_outline_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                msg,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
