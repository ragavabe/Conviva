import 'tipo_usuario.dart';

class Pessoa {
  final String nome;
  final String documento;
  final String? endereco;
  final String? telefone;
  final TipoUsuario tipo;

  Pessoa({
    required this.nome,
    required this.documento,
    this.endereco,
    this.telefone,
    required this.tipo,
  });
}
