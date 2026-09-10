enum UserRole { senior, organizer, driver }

class AppUser {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? phone;
  final String? address;
  final String? document; // CPF ou CNPJ para organizador
  final String? accessCode; // Código do motorista
  final String? pictureUrl; // Foto de perfil (Facebook ou rede)
  final String? profileUrl; // Link do perfil do Facebook

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.address,
    this.document,
    this.accessCode,
    this.pictureUrl,
    this.profileUrl,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return 'CO';
  }
}
