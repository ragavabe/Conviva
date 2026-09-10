import 'package:flutter/material.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/botao_gradiente.dart';
import '../../widgets/estado_vazio.dart';
import '../../widgets/header_gradiente.dart';
import '../../widgets/icone_circular.dart';
import 'card_organizador_evento.dart';

class OrganizadorDashboard extends StatefulWidget {
  const OrganizadorDashboard({super.key});

  @override
  State<OrganizadorDashboard> createState() => _OrganizadorDashboardState();
}

class _OrganizadorDashboardState extends State<OrganizadorDashboard> {
  final _novoEventoKey = GlobalKey<FormState>();
  final _titulo = TextEditingController();
  final _desc = TextEditingController();
  final _data = TextEditingController();
  final _hora = TextEditingController();
  final _local = TextEditingController();
  final _cap = TextEditingController(text: '10');

  @override
  void dispose() {
    _titulo.dispose();
    _desc.dispose();
    _data.dispose();
    _hora.dispose();
    _local.dispose();
    _cap.dispose();
    super.dispose();
  }

  void _adicionarEvento() {
    if (!_novoEventoKey.currentState!.validate()) return;
    AppState.instance.criarEvento(
      titulo: _titulo.text.trim(),
      descricao: _desc.text.trim(),
      data: _data.text.trim(),
      horario: _hora.text.trim(),
      local: _local.text.trim(),
      capacidade: int.tryParse(_cap.text.trim()) ?? 10,
    );
    _titulo.clear();
    _desc.clear();
    _data.clear();
    _hora.clear();
    _local.clear();
    _cap.text = '10';
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        backgroundColor: AppColors.sucesso,
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 10),
            Text('Evento criado com sucesso! 🎉'),
          ],
        ),
      ),
    );
  }

  void _mostrarDialogNovoEvento() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Form(
              key: _novoEventoKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.roxo, AppColors.roxoEscuro],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Novo Evento',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.texto,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _field(_titulo, 'Título', Icons.title_rounded),
                  _field(_desc, 'Descrição', Icons.description_outlined),
                  _field(
                    _data,
                    'Data (ex: 25/12/2025)',
                    Icons.calendar_today_rounded,
                  ),
                  _field(
                    _hora,
                    'Horário (ex: 15:00)',
                    Icons.access_time_rounded,
                  ),
                  _field(_local, 'Local', Icons.location_on_outlined),
                  _field(
                    _cap,
                    'Capacidade',
                    Icons.people_outline_rounded,
                    keyboard: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: BotaoGradiente(
                          texto: 'Criar',
                          icone: Icons.check_rounded,
                          cores: const [AppColors.roxo, AppColors.roxoEscuro],
                          onPressed: _adicionarEvento,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController c,
    String label,
    IconData icon, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        keyboardType: keyboard,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColors.roxo),
        ),
        validator: (v) =>
            (v == null || v.trim().isEmpty) ? 'Obrigatório' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: AppState.instance,
        builder: (context, _) {
          final eventos = AppState.instance.eventos;
          return Column(
            children: [
              HeaderGradiente(
                titulo: 'Painel do Organizador',
                subtitulo: '${eventos.length} evento(s) cadastrado(s)',
                icone: Icons.event_available_rounded,
                cores: const [AppColors.roxo, AppColors.roxoEscuro],
                altura: 200,
                trailing: IconeCircular(
                  icone: Icons.logout_rounded,
                  onTap: () => AppState.instance.logout(),
                ),
              ),
              Expanded(
                child: eventos.isEmpty
                    ? const EstadoVazio(
                        icone: Icons.event_busy_rounded,
                        titulo: 'Nenhum evento ainda',
                        sub: 'Toque no botão abaixo para criar o primeiro!',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                        itemCount: eventos.length,
                        itemBuilder: (_, i) =>
                            CardOrganizadorEvento(evento: eventos[i]),
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _mostrarDialogNovoEvento,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Novo Evento',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        backgroundColor: AppColors.roxo,
        foregroundColor: Colors.white,
        elevation: 6,
      ),
    );
  }
}
