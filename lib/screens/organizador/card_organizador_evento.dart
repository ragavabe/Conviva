import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:characters/characters.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../models/evento.dart';

class CardOrganizadorEvento extends StatelessWidget {
  final Evento evento;

  const CardOrganizadorEvento({super.key, required this.evento});

  String _iniciais(String nome) {
    final partes = nome
        .trim()
        .split(RegExp(r'\s+'))
        .where((parte) => parte.isNotEmpty);
    if (partes.isEmpty) return '?';
    return partes
        .take(2)
        .map((parte) => parte.characters.first)
        .join()
        .toUpperCase();
  }

  String _listaFormatada() {
    final pessoas = evento.participantes
        .asMap()
        .entries
        .map((entry) {
          final presente = evento.estaPresente(entry.value)
              ? 'Presente'
              : 'Ausente';
          return '${entry.key + 1}. ${entry.value} — $presente';
        })
        .join('\n');
    return '${evento.titulo}\n${evento.data} • ${evento.horario}\n\n'
        'Inscritos: ${evento.participantes.length}/${evento.capacidade}\n'
        'Presentes: ${evento.totalPresentes}\n'
        'Ausentes: ${evento.participantes.length - evento.totalPresentes}\n\n'
        '$pessoas';
  }

  Future<void> _adicionarPessoa(BuildContext context) async {
    final controller = TextEditingController();
    final nome = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar pessoa'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Nome do participante',
            hintText: 'Ex.: Maria da Silva',
          ),
          onSubmitted: (value) => Navigator.pop(context, value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (nome == null) return;
    final ok = AppState.instance.adicionarParticipanteManual(evento, nome);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: ok ? AppColors.sucesso : Colors.orange,
        content: Text(
          ok
              ? 'Participante adicionado à lista.'
              : 'Não foi possível adicionar. Verifique o nome ou as vagas.',
        ),
      ),
    );
  }

  Future<void> _confirmarRemocao(BuildContext context, String pessoa) async {
    final remover = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover participante?'),
        content: Text('Deseja remover $pessoa da lista?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remover'),
          ),
        ],
      ),
    );
    if (remover == true) AppState.instance.removerParticipante(evento, pessoa);
  }

  @override
  Widget build(BuildContext context) {
    final ausentes = evento.participantes.length - evento.totalPresentes;
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
                      Expanded(
                        child: Text(
                          'Lista de presença (${evento.participantes.length}/${evento.capacidade})',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Copiar lista',
                        onPressed: () async {
                          await Clipboard.setData(
                            ClipboardData(text: _listaFormatada()),
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Lista copiada para compartilhar.',
                                ),
                              ),
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.content_copy_rounded,
                          color: AppColors.roxo,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${evento.totalPresentes} presentes • $ausentes ausentes',
                    style: const TextStyle(
                      color: AppColors.textoSecundario,
                      fontSize: 13,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: evento.lotado || evento.realizado
                          ? null
                          : () => _adicionarPessoa(context),
                      icon: const Icon(Icons.person_add_alt_1_rounded),
                      label: const Text('Adicionar pessoa'),
                    ),
                  ),
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
                        padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
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
                                _iniciais(p),
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
                                p.trim().isEmpty ? 'Participante' : p,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () =>
                                  AppState.instance.alternarPresenca(evento, p),
                              icon: Icon(
                                evento.estaPresente(p)
                                    ? Icons.check_circle_rounded
                                    : Icons.radio_button_unchecked_rounded,
                                size: 18,
                              ),
                              label: Text(
                                evento.estaPresente(p) ? 'Presente' : 'Ausente',
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: evento.estaPresente(p)
                                    ? AppColors.sucesso
                                    : AppColors.textoSecundario,
                              ),
                            ),
                            IconButton(
                              tooltip: 'Remover participante',
                              visualDensity: VisualDensity.compact,
                              icon: const Icon(
                                Icons.close_rounded,
                                color: AppColors.textoSecundario,
                              ),
                              onPressed: () => _confirmarRemocao(context, p),
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
