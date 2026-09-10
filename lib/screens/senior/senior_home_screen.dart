import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../core/typography.dart';
import '../../core/state.dart';
import '../../models/event.dart';
import '../../widgets/event_card.dart';
import '../../widgets/audio_assist_banner.dart';
import '../../widgets/mockup_inspection_sheet.dart';
import '../organizer/create_event_screen.dart';
import 'event_details_screen.dart';
import 'senior_transport_screen.dart';

class SeniorHomeScreen extends StatefulWidget {
  const SeniorHomeScreen({super.key});

  @override
  State<SeniorHomeScreen> createState() => _SeniorHomeScreenState();
}

class _SeniorHomeScreenState extends State<SeniorHomeScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'Todos';
  String _selectedStatusFilter = 'Todos';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bom dia';
    if (hour < 18) return 'Boa tarde';
    return 'Boa noite';
  }

  void _openMockupsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const MockupInspectionSheet(),
    );
  }

  void _openVoiceSearchDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: ConvivaColors.border,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: ConvivaColors.pineGreenLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mic_rounded,
                color: ConvivaColors.pineGreen,
                size: 42,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ouvindo sua voz...',
              style: ConvivaTypography.titleSerifMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Diga o que você gostaria de fazer ou toque em uma das sugestões abaixo:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: ConvivaColors.textSecondary),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                _buildVoiceTag('🎨 Artesanato'),
                _buildVoiceTag('🎲 Bingo'),
                _buildVoiceTag('🚶‍♀️ Caminhada'),
                _buildVoiceTag('☕ Café com Prosa'),
                _buildVoiceTag('🎵 Música'),
              ],
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => Navigator.pop(ctx),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Fechar microfone'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceTag(String text) {
    return ActionChip(
      label: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      backgroundColor: ConvivaColors.background,
      side: const BorderSide(color: ConvivaColors.border),
      onPressed: () {
        final cleanText = text.replaceAll(RegExp(r'[^\w\s]'), '').trim();
        setState(() {
          _searchCtrl.text = cleanText;
          _searchQuery = cleanText;
        });
        Navigator.pop(context);
      },
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

        // Filtragem combinada (Pesquisa + Categoria + Status)
        final query = _searchQuery.toLowerCase().trim();
        final filteredEvents = allEvents.where((e) {
          // Filtro por status
          if (_selectedStatusFilter == 'Em breve' && e.status != EventStatus.upcoming) {
            return false;
          }
          if (_selectedStatusFilter == 'Lotados' && e.status != EventStatus.full) {
            return false;
          }
          if (_selectedStatusFilter == 'Aconteceu' && e.status != EventStatus.completed) {
            return false;
          }
          if (_selectedStatusFilter == 'Meus' && !e.isUserParticipating) {
            return false;
          }

          // Filtro por Categoria
          if (_selectedCategory != 'Todos' &&
              !e.category.toLowerCase().contains(_selectedCategory.toLowerCase())) {
            return false;
          }

          // Filtro por busca textual
          if (query.isNotEmpty) {
            final matchTitle = e.title.toLowerCase().contains(query);
            final matchCat = e.category.toLowerCase().contains(query);
            final matchLoc = e.location.toLowerCase().contains(query);
            return matchTitle || matchCat || matchLoc;
          }
          return true;
        }).toList();

        // Evento em destaque (primeiro evento com status 'upcoming')
        final spotlightEvent = allEvents.firstWhere(
          (e) => e.status == EventStatus.upcoming,
          orElse: () => allEvents.first,
        );

        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              children: [
                // Banner de Leitura de Tela (quando ativado)
                const AudioAssistBanner(),

                // BARRA SUPERIOR ACOLHEDORA: Saudação + Acessibilidade
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${_getGreeting()}, ${user?.name ?? 'Dona Marta'}',
                                style: ConvivaTypography.titleSerifLarge.copyWith(
                                  fontSize: 26,
                                  color: ConvivaColors.pineGreenDark,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text('🌸', style: TextStyle(fontSize: 24)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Hoje é um ótimo dia para encontrar amigos!',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: ConvivaColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      radius: 24,
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
                                fontSize: 18,
                              ),
                            )
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // BARRA DE ATALHOS DE ACESSIBILIDADE PARA IDOSOS
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: ConvivaColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Botão Aumentar Letra
                      Expanded(
                        child: InkWell(
                          onTap: () => state.toggleTextScale(),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: state.isLargeText
                                  ? ConvivaColors.pineGreenLight
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.text_fields_rounded,
                                  size: 20,
                                  color: state.isLargeText
                                      ? ConvivaColors.pineGreen
                                      : ConvivaColors.textSecondary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  state.isLargeText ? 'Letra: Grande' : 'Aa+ Aumentar',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: state.isLargeText
                                        ? ConvivaColors.pineGreen
                                        : ConvivaColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(height: 24, width: 1, color: ConvivaColors.border),
                      // Botão Ler para mim
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (state.isSpeaking) {
                              state.stopSpeaking();
                            } else {
                              state.speak(
                                'Olá, Dona Marta! Você tem ${allEvents.length} atividades disponíveis. O destaque desta semana é o ${spotlightEvent.title}, que acontece em ${spotlightEvent.dateFormatted}.',
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: state.isSpeaking
                                  ? ConvivaColors.terracottaLight
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  state.isSpeaking
                                      ? Icons.volume_off_rounded
                                      : Icons.volume_up_rounded,
                                  size: 20,
                                  color: state.isSpeaking
                                      ? ConvivaColors.terracotta
                                      : ConvivaColors.pineGreen,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  state.isSpeaking ? 'Parar Voz' : '🔊 Ler para mim',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: state.isSpeaking
                                        ? ConvivaColors.terracotta
                                        : ConvivaColors.pineGreenText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // DESTAQUE DA SEMANA (CARD HEROICO E CONVIDATIVO)
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EventDetailsScreen(eventId: spotlightEvent.id),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [ConvivaColors.pineGreen, ConvivaColors.pineGreenDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: ConvivaColors.pineGreen.withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade300,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.star_rounded, size: 16, color: Colors.black87),
                                  SizedBox(width: 4),
                                  Text(
                                    'Destaque da Semana',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            const Text('🌟', style: TextStyle(fontSize: 20)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          spotlightEvent.title,
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_rounded, size: 16, color: Colors.white70),
                            const SizedBox(width: 6),
                            Text(
                              spotlightEvent.dateFormatted,
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.place_rounded, size: 16, color: Colors.white70),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                spotlightEvent.location,
                                style: const TextStyle(color: Colors.white70, fontSize: 13),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Quero Conhecer ✨',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: ConvivaColors.pineGreen,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(Icons.arrow_forward_rounded, size: 16, color: ConvivaColors.pineGreen),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // BARRA DE PESQUISA COM ATALHO DE VOZ
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: ConvivaColors.border, width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'O que você quer fazer hoje? (Ex: Bingo, Artesanato)',
                      hintStyle: const TextStyle(fontSize: 14, color: ConvivaColors.textMuted),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: ConvivaColors.pineGreen,
                        size: 26,
                      ),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_searchQuery.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 20),
                              onPressed: () {
                                _searchCtrl.clear();
                                setState(() => _searchQuery = '');
                              },
                            ),
                          IconButton(
                            icon: const Icon(
                              Icons.mic_rounded,
                              color: ConvivaColors.pineGreen,
                              size: 24,
                            ),
                            tooltip: 'Falar ao invés de digitar',
                            onPressed: () => _openVoiceSearchDialog(context),
                          ),
                        ],
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // CARROSSEL HORIZONTAL DE CATEGORIAS AMIGÁVEIS
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Categorias de Atividades',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: ConvivaColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildCategoryBadge('Todos', '🌟 Todos'),
                          const SizedBox(width: 8),
                          _buildCategoryBadge('Artesanato', '🎨 Artesanato'),
                          const SizedBox(width: 8),
                          _buildCategoryBadge('Bingo', '🎲 Bingo & Jogos'),
                          const SizedBox(width: 8),
                          _buildCategoryBadge('Caminhada', '🚶‍♀️ Caminhadas'),
                          const SizedBox(width: 8),
                          _buildCategoryBadge('Música', '🎵 Música'),
                          const SizedBox(width: 8),
                          _buildCategoryBadge('Café', '☕ Café & Prosa'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // BANNER REASSURADOR DE CARONA SOLIDÁRIA
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ConvivaColors.ochreLight,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: ConvivaColors.ochre.withValues(alpha: 0.35)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: ConvivaColors.ochre.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.directions_car_filled_rounded,
                          color: ConvivaColors.ochreDark,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Precisa de carona para o evento?',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: ConvivaColors.ochreDark,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Nossos motoristas voluntários te buscam e levam com total segurança.',
                              style: TextStyle(
                                fontSize: 13,
                                color: ConvivaColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SeniorTransportScreen(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 18,
                          color: ConvivaColors.ochreDark,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // FILTROS DE STATUS
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildStatusChip('Todos', 'Todos', allEvents.length),
                      const SizedBox(width: 8),
                      _buildStatusChip(
                        '🌱 Em breve',
                        'Em breve',
                        allEvents.where((e) => e.status == EventStatus.upcoming).length,
                      ),
                      const SizedBox(width: 8),
                      _buildStatusChip(
                        '🔒 Lotados',
                        'Lotados',
                        allEvents.where((e) => e.status == EventStatus.full).length,
                      ),
                      const SizedBox(width: 8),
                      _buildStatusChip(
                        '✨ Já Aconteceu',
                        'Aconteceu',
                        allEvents.where((e) => e.status == EventStatus.completed).length,
                      ),
                      const SizedBox(width: 8),
                      _buildStatusChip(
                        '⭐ Meus Eventos',
                        'Meus',
                        allEvents.where((e) => e.isUserParticipating).length,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // CABEÇALHO DA LISTA
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Próximas Atividades (${filteredEvents.length})',
                      style: const TextStyle(
                        fontFamily: 'serif',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ConvivaColors.textPrimary,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => _openMockupsModal(context),
                          icon: const Icon(Icons.palette_outlined, size: 20, color: ConvivaColors.textSecondary),
                          tooltip: 'Inspecionar Mockups do Hackathon',
                        ),
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
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            minimumSize: const Size(0, 36),
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
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: ConvivaColors.border),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.search_off_rounded,
                          size: 54,
                          color: ConvivaColors.textMuted,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Nenhuma atividade encontrada',
                          style: ConvivaTypography.titleSerifSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Tente pesquisar por outro nome ou limpe os filtros para ver todas as atividades.',
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
                              _selectedCategory = 'Todos';
                              _selectedStatusFilter = 'Todos';
                            });
                          },
                          child: const Text('Mostrar todas as atividades'),
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
                              builder: (_) => EventDetailsScreen(eventId: event.id),
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

  Widget _buildCategoryBadge(String key, String label) {
    final isSelected = _selectedCategory.toLowerCase() == key.toLowerCase();
    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = isSelected ? 'Todos' : key;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? ConvivaColors.pineGreen : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? ConvivaColors.pineGreen : ConvivaColors.border,
            width: 1.2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: ConvivaColors.pineGreen.withValues(alpha: 0.25),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : ConvivaColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, String value, int count) {
    final isSelected = _selectedStatusFilter == value;
    return ChoiceChip(
      label: Text('$label ($count)'),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) setState(() => _selectedStatusFilter = value);
      },
      selectedColor: ConvivaColors.pineGreenLight,
      backgroundColor: Colors.white,
      side: BorderSide(
        color: isSelected ? ConvivaColors.pineGreen : ConvivaColors.border,
      ),
      labelStyle: TextStyle(
        fontSize: 13,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        color: isSelected ? ConvivaColors.pineGreenText : ConvivaColors.textSecondary,
      ),
    );
  }
}
