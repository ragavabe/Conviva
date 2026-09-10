class Evento {
  final String id;
  String titulo;
  String descricao;
  String data;
  String horario;
  String local;
  int capacidade;
  final List<String> participantes;
  final Set<String> presentes;
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
    Set<String>? presentes,
    this.realizado = false,
  })  : participantes = participantes ?? [],
        presentes = presentes ?? {};

  bool get lotado => participantes.length >= capacidade;
  int get vagasRestantes => capacidade - participantes.length;
  int get totalPresentes => presentes.length;
  bool estaPresente(String nome) => presentes.contains(nome);
}

