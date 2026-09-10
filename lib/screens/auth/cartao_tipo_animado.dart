import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/tipo_usuario.dart';

class CartaoTipoAnimado extends StatefulWidget {
  final TipoUsuario tipo;
  final VoidCallback onTap;
  final int delay;

  const CartaoTipoAnimado({
    super.key,
    required this.tipo,
    required this.onTap,
    required this.delay,
  });

  @override
  State<CartaoTipoAnimado> createState() => _CartaoTipoAnimadoState();
}

class _CartaoTipoAnimadoState extends State<CartaoTipoAnimado>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fade = CurvedAnimation(parent: _c, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _c, curve: Curves.easeOutCubic));
    Future.delayed(Duration(milliseconds: widget.delay), () {
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
    final t = widget.tipo;
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          elevation: 0,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppShadows.suave,
                border: Border.all(color: t.cor.withValues(alpha: 0.12), width: 1.4),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: t.gradiente,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: AppShadows.colorida(t.cor),
                    ),
                    child: Icon(t.icone, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.label,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.texto,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          t.descricao,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textoSecundario,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, color: t.cor, size: 18),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
