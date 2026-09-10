import 'package:flutter/material.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../models/pessoa.dart';
import '../../models/tipo_usuario.dart';
import '../../widgets/botao_gradiente.dart';
import '../../widgets/header_gradiente.dart';

class FormularioPage extends StatefulWidget {
  final TipoUsuario tipo;
  final VoidCallback onVoltar;

  const FormularioPage({
    super.key,
    required this.tipo,
    required this.onVoltar,
  });

  @override
  State<FormularioPage> createState() => _FormularioPageState();
}

class _FormularioPageState extends State<FormularioPage> {
  final _formKey = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _doc = TextEditingController();
  final _end = TextEditingController();
  final _tel = TextEditingController();

  @override
  void dispose() {
    _nome.dispose();
    _doc.dispose();
    _end.dispose();
    _tel.dispose();
    super.dispose();
  }

  void _entrar() {
    if (!_formKey.currentState!.validate()) return;
    AppState.instance.login(
      Pessoa(
        nome: _nome.text.trim(),
        documento: _doc.text.trim(),
        endereco: widget.tipo == TipoUsuario.usuario ? _end.text.trim() : null,
        telefone:
            (widget.tipo == TipoUsuario.usuario ||
                widget.tipo == TipoUsuario.motorista)
            ? _tel.text.trim()
            : null,
        tipo: widget.tipo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.tipo;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        children: [
          HeaderGradiente(
            titulo: 'Cadastro de ${t.label}',
            subtitulo: t.descricao,
            icone: t.icone,
            cores: t.gradiente,
            altura: 220,
            onVoltar: widget.onVoltar,
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(26),
                boxShadow: AppShadows.media,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildField(
                      _nome,
                      t == TipoUsuario.organizador
                          ? 'Nome da instituição / responsável'
                          : 'Nome completo',
                      Icons.person_outline_rounded,
                    ),
                    const SizedBox(height: 16),
                    _buildField(
                      _doc,
                      t == TipoUsuario.organizador ? 'CPF ou CNPJ' : 'CPF',
                      Icons.badge_outlined,
                    ),
                    if (t == TipoUsuario.usuario) ...[
                      const SizedBox(height: 16),
                      _buildField(_end, 'Endereço', Icons.home_outlined),
                      const SizedBox(height: 16),
                      _buildField(
                        _tel,
                        'Telefone',
                        Icons.phone_outlined,
                        keyboard: TextInputType.phone,
                      ),
                    ],
                    const SizedBox(height: 26),
                    BotaoGradiente(
                      texto: 'Entrar',
                      icone: Icons.login_rounded,
                      cores: t.gradiente,
                      onPressed: _entrar,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    TextEditingController c,
    String label,
    IconData icon, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      controller: c,
      keyboardType: keyboard,
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: widget.tipo.cor),
      ),
      validator: (v) => (v == null || v.trim().isEmpty) ? 'Obrigatório' : null,
    );
  }
}
