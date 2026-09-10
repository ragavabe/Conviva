import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../../models/pessoa.dart';
import '../../models/tipo_usuario.dart';

class FacebookAuthResult {
  final bool isSuccess;
  final bool isCancelled;
  final String? errorMessage;
  final Pessoa? pessoa;

  const FacebookAuthResult._({
    required this.isSuccess,
    this.isCancelled = false,
    this.errorMessage,
    this.pessoa,
  });

  factory FacebookAuthResult.success(Pessoa pessoa) =>
      FacebookAuthResult._(isSuccess: true, pessoa: pessoa);

  factory FacebookAuthResult.cancelled() =>
      const FacebookAuthResult._(isSuccess: false, isCancelled: true);

  factory FacebookAuthResult.failure(String message) =>
      FacebookAuthResult._(isSuccess: false, errorMessage: message);
}

/// Serviço de integração com o Facebook SDK.
/// Não há backend: autentica localmente com o SDK do Facebook,
/// obtém os dados públicos (nome, email, foto) via Graph API,
/// e cria uma Pessoa com o tipo selecionado.
class FacebookAuthService {
  static final FacebookAuthService instance = FacebookAuthService._();
  FacebookAuthService._();

  /// Realiza o login com Facebook e monta uma [Pessoa] com o [tipo] escolhido.
  Future<FacebookAuthResult> login({required TipoUsuario tipo}) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: const ['public_profile', 'email'],
      );

      switch (result.status) {
        case LoginStatus.success:
          final userData = await FacebookAuth.instance.getUserData(
            fields: 'id,name,email,picture.width(300)',
          );

          final id = userData['id'] as String? ??
              'fb_${DateTime.now().millisecondsSinceEpoch}';
          final nome = userData['name'] as String? ?? 'Usuário Facebook';
          final telefone = userData['email'] as String?;

          final pessoa = Pessoa(
            nome: nome,
            // O Facebook não fornece CPF/RG: usamos o ID do Facebook como
            // documento placeholder, já que este app é uma demo sem backend.
            documento: 'FB-$id',
            telefone: telefone,
            tipo: tipo,
          );

          return FacebookAuthResult.success(pessoa);

        case LoginStatus.cancelled:
          return FacebookAuthResult.cancelled();

        case LoginStatus.failed:
          return FacebookAuthResult.failure(
            result.message ?? 'Falha na autenticação com o Facebook.',
          );

        default:
          return FacebookAuthResult.failure('Ocorreu um erro inesperado no login.');
      }
    } catch (e) {
      debugPrint('Erro FacebookAuth: $e');
      return FacebookAuthResult.failure(
        'Não foi possível conectar com o Facebook: $e',
      );
    }
  }

  /// Desconecta a sessão ativa do Facebook SDK
  Future<void> logOut() async {
    try {
      await FacebookAuth.instance.logOut();
    } catch (e) {
      debugPrint('Erro ao desconectar do Facebook: $e');
    }
  }
}