import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../../models/app_user.dart';

class FacebookAuthResult {
  final bool isSuccess;
  final bool isCancelled;
  final String? errorMessage;
  final AppUser? user;

  const FacebookAuthResult._({
    required this.isSuccess,
    this.isCancelled = false,
    this.errorMessage,
    this.user,
  });

  factory FacebookAuthResult.success(AppUser user) =>
      FacebookAuthResult._(isSuccess: true, user: user);

  factory FacebookAuthResult.cancelled() =>
      const FacebookAuthResult._(isSuccess: false, isCancelled: true);

  factory FacebookAuthResult.failure(String message) =>
      FacebookAuthResult._(isSuccess: false, errorMessage: message);
}

/// Serviço de integração com o Facebook SDK.
/// Não há backend: autentica localmente com o SDK do Facebook,
/// obtém os dados públicos (nome, email, foto, link) via Graph API,
/// e cria um AppUser com o papel selecionado.
class FacebookAuthService {
  static final FacebookAuthService instance = FacebookAuthService._();
  FacebookAuthService._();

  /// Realiza o login com Facebook
  Future<FacebookAuthResult> login({
    UserRole role = UserRole.senior,
  }) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: const ['public_profile', 'email'],
      );

      switch (result.status) {
        case LoginStatus.success:
          final userData = await FacebookAuth.instance.getUserData(
            fields: 'id,name,email,picture.width(300),link',
          );

          final id = userData['id'] as String? ?? 'fb_${DateTime.now().millisecondsSinceEpoch}';
          final name = userData['name'] as String? ?? 'Usuário Facebook';
          final email = userData['email'] as String? ?? '$id@facebook.com';
          final pictureUrl = userData['picture']?['data']?['url'] as String?;
          final profileUrl = userData['link'] as String?;

          final appUser = AppUser(
            id: id,
            name: name,
            email: email,
            role: role,
            pictureUrl: pictureUrl,
            profileUrl: profileUrl,
            phone: '(11) 98765-4321', // Padrão acolhedor para a demo
            address: 'São Paulo, SP',
          );

          return FacebookAuthResult.success(appUser);

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
