import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../core/typography.dart';
import '../../core/state.dart';
import '../../models/event.dart';

class CreateEventScreen extends StatefulWidget {
  final ConvivaEvent? eventToEdit;

  const CreateEventScreen({super.key, this.eventToEdit});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _dateCtrl;
  late TextEditingController _locationCtrl;
  late TextEditingController _categoryCtrl;
  late TextEditingController _maxSpotsCtrl;

  @override
  void initState() {
    super.initState();
    final ev = widget.eventToEdit;
    _titleCtrl = TextEditingController(
      text: ev?.title ?? 'Chá das Quatro e Roda de Conversa',
    );
    _descCtrl = TextEditingController(
      text: ev?.description ??
          'Um momento acolhedor para compartilhar histórias, saborear chás artesanais e fazer novas amizades na nossa comunidade.',
    );
    _dateCtrl = TextEditingController(
      text: ev?.dateFormatted ?? 'Terça, 24 de setembro · 15h00',
    );
    _locationCtrl = TextEditingController(
      text: ev?.location ?? 'Centro Cultural Comunitário - Sala 2',
    );
    _categoryCtrl = TextEditingController(
      text: ev?.category ?? 'Convivência & Café',
    );
    _maxSpotsCtrl = TextEditingController(
      text: ev?.maxSpots.toString() ?? '25',
    );
  }

  void _saveEvent() {
    if (_formKey.currentState!.validate()) {
      final state = ConvivaState.instance;
      final max = int.tryParse(_maxSpotsCtrl.text) ?? 30;

      if (widget.eventToEdit != null) {
        final updated = widget.eventToEdit!;
        updated.title = _titleCtrl.text.trim();
        updated.description = _descCtrl.text.trim();
        updated.dateFormatted = _dateCtrl.text.trim();
        updated.location = _locationCtrl.text.trim();
        updated.category = _categoryCtrl.text.trim();
        updated.maxSpots = max;
        state.updateEvent(updated);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Evento atualizado com sucesso!')),
        );
      } else {
        final newEvent = ConvivaEvent(
          id: 'ev_${DateTime.now().millisecondsSinceEpoch}',
          title: _titleCtrl.text.trim(),
          dateFormatted: _dateCtrl.text.trim(),
          location: _locationCtrl.text.trim(),
          distance: '0,8 km de você',
          category: _categoryCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          status: EventStatus.upcoming,
          confirmedCount: 1,
          maxSpots: max,
          organizerId: state.currentUser?.id ?? 'org_carlos',
          participants: [
            EventParticipant(
              id: 'p_demo',
              name: 'Dona Marta',
              initials: 'DM',
              timeAgo: 'Confirmou hoje',
              phone: '(11) 98765-4321',
              isPresent: true,
            ),
          ],
        );
        state.addEvent(newEvent);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Evento criado com sucesso! Já está visível para os idosos.',
            ),
            backgroundColor: ConvivaColors.pineGreen,
          ),
        );
      }

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.eventToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Evento' : 'Criar Novo Evento'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleCtrl,
                style: const TextStyle(fontSize: 17),
                decoration: const InputDecoration(
                  labelText: 'Nome do evento',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (v) =>
                    v!.isEmpty ? 'Informe o nome do evento' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryCtrl,
                style: const TextStyle(fontSize: 17),
                decoration: const InputDecoration(
                  labelText:
                      'Categoria (ex: Artesanato, Dança, Jogos, Caminhada)',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                validator: (v) => v!.isEmpty ? 'Informe a categoria' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateCtrl,
                style: const TextStyle(fontSize: 17),
                decoration: const InputDecoration(
                  labelText: 'Data e Horário (ex: Sábado, 14 de setembro · 14h)',
                  prefixIcon: Icon(Icons.event_outlined),
                ),
                validator: (v) => v!.isEmpty ? 'Informe data e horário' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationCtrl,
                style: const TextStyle(fontSize: 17),
                decoration: const InputDecoration(
                  labelText: 'Endereço completo / Local',
                  prefixIcon: Icon(Icons.place_outlined),
                ),
                validator: (v) => v!.isEmpty ? 'Informe o local' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _maxSpotsCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 17),
                decoration: const InputDecoration(
                  labelText: 'Número máximo de vagas (opcional)',
                  prefixIcon: Icon(Icons.people_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descCtrl,
                maxLines: 4,
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                  labelText: 'Descrição acolhedora do evento',
                  alignLabelWithHint: true,
                ),
                validator: (v) => v!.isEmpty ? 'Descreva o evento' : null,
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: _saveEvent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ConvivaColors.pineGreen,
                ),
                child: Text(isEditing ? 'Salvar Alterações' : 'Criar Evento'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
