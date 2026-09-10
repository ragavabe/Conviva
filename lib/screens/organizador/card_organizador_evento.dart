import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/evento.dart';

class CardOrganizadorEvento extends StatelessWidget {
  final Evento evento;

  const CardOrganizadorEvento({
    super.key,
    required this.evento,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(22),
        boxShadow: AppShadows.suave,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.roxo, AppColors.roxoEscuro],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                '${evento.participantes.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          title: Text(
            evento.titulo,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 17,
              color: AppColors.texto,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '${evento.data} • ${evento.horario}\n${evento.local}',
              style: const TextStyle(
                fontSize: 13.5,
                color: AppColors.textoSecundario,
                height: 1.3,
              ),
            ),
          ),
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.fundo,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    evento.descricao,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.texto,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Icon(
                        Icons.people_alt_rounded,
                        size: 18,
                        color: AppColors.roxo,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Lista de presença (${evento.participantes.length}/${evento.capacidade})',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppColors.texto,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (evento.participantes.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Ninguém confirmou ainda.',
                        style: TextStyle(
                          color: AppColors.textoSecundario,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ...evento.participantes.map(
                    (p) => Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: AppShadows.suave,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: AppColors.roxoClaro,
                              child: Text(
                                p.substring(0, 1).toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                p,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              icon: const Icon(
                                Icons.facebook_rounded,
                                color: Color(0xFF1877F2),
                              ),
                              onPressed: () => ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      content: Text(
                                        'Abrindo Facebook de $p...',
                                      ),
                                    ),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
