import 'package:flutter/material.dart';

import '../../models/pessoa.dart';
import '../../models/evento.dart';

class AppState extends ChangeNotifier {
  AppState._();
  static final AppState instance = AppState._();

  Pessoa? usuarioLogado;

  final List<Evento> eventos = [
    Evento(
      id: '1',
      titulo: 'Baile da Terceira Idade',
      descricao:
          'Venha dançar forró, bolero e samba com outros idosos animados!',
      data: '15/12/2025',
      horario: '19:00',
      local: 'Clube Municipal — Centro',
      capacidade: 10,
      participantes: ['Dona Maria', 'Seu João'],
    ),
    Evento(
      id: '2',
      titulo: 'Tarde de Bingo',
      descricao: 'Bingo com prêmios, café e bolo. Traga sua sorte!',
      data: '20/12/2025',
      horario: '14:00',
      local: 'Salão da Igreja São José',
      capacidade: 3,
      participantes: ['Ana', 'Carlos', 'Beatriz'],
    ),
    Evento(
      id: '3',
      titulo: 'Caminhada no Parque',
      descricao: 'Caminhada leve seguida de piquenique no parque central.',
      data: '01/12/2025',
      horario: '08:00',
      local: 'Parque da Cidade',
      capacidade: 20,
      participantes: ['Pedro', 'Lúcia', 'Marcos', 'Rita'],
      realizado: true,
    ),
  ];

  void login(Pessoa p) {
    usuarioLogado = p;
    notifyListeners();
  }

  void logout() {
    usuarioLogado = null;
    notifyListeners();
  }

  void criarEvento({
    required String titulo,
    required String descricao,
    required String data,
    required String horario,
    required String local,
    required int capacidade,
  }) {
    eventos.insert(
      0,
      Evento(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        titulo: titulo,
        descricao: descricao,
        data: data,
        horario: horario,
        local: local,
        capacidade: capacidade,
      ),
    );
    notifyListeners();
  }

  bool participar(Evento e) {
    final user = usuarioLogado;
    if (user == null || e.realizado || e.lotado) return false;
    if (e.participantes.contains(user.nome)) return false;
    e.participantes.add(user.nome);
    notifyListeners();
    return true;
  }

  /// Marca ou desmarca o comparecimento de uma pessoa inscrita.
  void alternarPresenca(Evento e, String participante) {
    if (!e.participantes.contains(participante)) return;
    if (!e.presentes.add(participante)) {
      e.presentes.remove(participante);
    }
    notifyListeners();
  }

  /// Inclui uma inscrição feita pelo telefone ou no balcão.
  bool adicionarParticipanteManual(Evento e, String nome) {
    final nomeLimpo = nome.trim();
    if (nomeLimpo.isEmpty || e.realizado || e.lotado) return false;
    if (e.participantes.any(
      (participante) => participante.toLowerCase() == nomeLimpo.toLowerCase(),
    )) {
      return false;
    }
    e.participantes.add(nomeLimpo);
    notifyListeners();
    return true;
  }

  /// Remove uma inscrição e também qualquer check-in associado a ela.
  bool removerParticipante(Evento e, String nome) {
    if (!e.participantes.remove(nome)) return false;
    e.presentes.remove(nome);
    notifyListeners();
    return true;
  }

  /// Cancela a inscrição do usuário atual, liberando a vaga imediatamente.
  bool cancelarParticipacao(Evento e) {
    final user = usuarioLogado;
    if (user == null || !e.participantes.remove(user.nome)) return false;
    e.presentes.remove(user.nome);
    notifyListeners();
    return true;
  }

  bool confirmarPresencaRealizado(Evento e) {
    final user = usuarioLogado;
    if (user == null || !e.realizado) return false;
    if (e.participantes.contains(user.nome)) return false;
    e.participantes.add(user.nome);
    notifyListeners();
    return true;
  }
}
