import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../core/typography.dart';
import '../../core/state.dart';
import '../../models/event.dart';
import '../../widgets/event_card.dart';
import '../../widgets/persona_switcher.dart';
import '../../widgets/mockup_inspection_sheet.dart';
import '../organizer/create_event_screen.dart';
import 'event_details_screen.dart';

class SeniorHomeScreen extends StatefulWidget {
  const SeniorHomeScreen({super.key});

  @override
  State<SeniorHomeScreen> createState() => _SeniorHomeScreenState();
}

class _SeniorHomeScreenState extends State<SeniorHomeScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'Todos';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _openMockupsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const MockupInspectionSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ConvivaState.instance;

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final user = state.currentUser;
        final allEvents = state.events;

        // Filtragem em tempo real
        final query = _searchQuery.toLowerCase().trim();
        final filteredEvents = allEvents.where((e) {
          if (_selectedFilter == 'Em breve' && e.status != EventStatus.upcoming) {
            return false;
          }
          if (_selectedFilter == 'Lotados' && e.status != EventStatus.full) {
            return false;
          }
          if (_selectedFilter == 'Aconteceu' && e.status != EventStatus.completed) {
            return false;
          }
          if (_selectedFilter == 'Meus' && !e.isUserParticipating) {
            return false;
          }
          if (query.isNotEmpty) {
            final matchTitle = e.title.toLowerCase().contains(query);
            final matchCat = e.category.toLowerCase().contains(query);
            final matchLoc = e.location.toLowerCase().contains(query);
            return matchTitle || matchCat || matchLoc;
          }
          return true;
        }).toList();

        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                // Barra de Troca Rápida de Persona
                const PersonaSwitcher(),

                // Cabeçalho acolhedor com Saudação
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Olá, ${user?.name ?? 'Dona Marta'}',
                                style: ConvivaTypography.titleSerifLarge,
                              ),
                              const SizedBox(width: 8),
                              const Text('👋', style: TextStyle(fontSize: 26)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Veja o que está acontecendo perto de você',
                            style: TextStyle(
                              fontSize: 16,
                              color: ConvivaColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: ConvivaColors.pineGreenLight,
                      backgroundImage: user?.pictureUrl != null
                          ? NetworkImage(user!.pictureUrl!)
                          : null,
                      child: user?.pictureUrl == null
                          ? Text(
                              user?.initials ?? 'DM',
                              style: const TextStyle(
                                fontFamily: 'serif',
                                fontWeight: FontWeight.bold,
                                color: ConvivaColors.pineGreen,
                                fontSize: 16,
                              ),
                            )
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // BARRA DE PESQUISA EM TEMPO REAL
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: ConvivaColors.border, width: 1.2),
                  ),
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'Buscar evento, local ou oficina...',
                      hintStyle: const TextStyle(
                        fontSize: 15,
                        color: ConvivaColors.textMuted,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: ConvivaColors.pineGreen,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 20),
                              onPressed: () {
                                _searchCtrl.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // FILTROS HORIZONTAIS EM CHIPS
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Todos', 'Todos', allEvents.length),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        '🌱 Em breve',
                        'Em breve',
                        allEvents.where((e) => e.status == EventStatus.upcoming).length,
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        '🔒 Lotados',
                        'Lotados',
                        allEvents.where((e) => e.status == EventStatus.full).length,
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        '✨ Aconteceu',
                        'Aconteceu',
                        allEvents.where((e) => e.status == EventStatus.completed).length,
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        '⭐ Meus Eventos',
                        'Meus',
                        allEvents.where((e) => e.isUserParticipating).length,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // CABEÇALHO DA LISTA + BOTÕES DE AÇÃO
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Eventos (${filteredEvents.length})',
                      style: const TextStyle(
                        fontFamily: 'serif',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ConvivaColors.textPrimary,
                      ),
                    ),
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => _openMockupsModal(context),
                          icon: const Icon(Icons.photo_library_outlined, size: 16),
                          label: const Text('Mockups', style: TextStyle(fontSize: 13)),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            minimumSize: const Size(0, 34),
                            side: const BorderSide(color: ConvivaColors.border),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CreateEventScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('+ Criar', style: TextStyle(fontSize: 13)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ConvivaColors.pineGreen,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            minimumSize: const Size(0, 34),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // LISTA DE CARDS OU ESTADO VAZIO
                if (filteredEvents.isEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(32),
                    margin: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: ConvivaColors.border),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.event_busy_outlined,
                          size: 52,
                          color: ConvivaColors.textMuted,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Nenhum evento encontrado',
                          style: ConvivaTypography.titleSerifSmall,
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Tente buscar por outro termo ou limpe os filtros para ver todas as atividades.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: ConvivaColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 18),
                        OutlinedButton(
                          onPressed: () {
                            _searchCtrl.clear();
                            setState(() {
                              _searchQuery = '';
                              _selectedFilter = 'Todos';
                            });
                          },
                          child: const Text('Limpar Filtros'),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  ...filteredEvents.map(
                    (event) => Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: EventCard(
                        event: event,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EventDetailsScreen(eventId: event.id),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String label, String value, int count) {
    final isSelected = _selectedFilter == value;
    return ChoiceChip(
      label: Text('$label ($count)'),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) setState(() => _selectedFilter = value);
      },
      selectedColor: ConvivaColors.pineGreenLight,
      backgroundColor: Colors.white,
      side: BorderSide(
        color: isSelected ? ConvivaColors.pineGreen : ConvivaColors.border,
      ),
      labelStyle: TextStyle(
        fontSize: 13,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected ? ConvivaColors.pineGreenText : ConvivaColors.textSecondary,
      ),
    );
  }
}
