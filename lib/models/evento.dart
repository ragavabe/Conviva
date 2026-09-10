class Evento {
  final String id;
  String titulo;
  String descricao;
  String data;
  String horario;
  String local;
  int capacidade;
  final List<String> participantes;
  bool realizado;

  Evento({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.data,
    required this.horario,
    required this.local,
    required this.capacidade,
    List<String>? participantes,
    this.realizado = false,
  }) : participantes = participantes ?? [];

  bool get lotado => participantes.length >= capacidade;
  int get vagasRestantes => capacidade - participantes.length;
}
