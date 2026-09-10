import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../core/typography.dart';
import '../core/state.dart';

class MockupInspectionSheet extends StatelessWidget {
  const MockupInspectionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Visualizador de Mockups',
                style: ConvivaTypography.titleSerifMedium,
              ),
            ),
            const TabBar(
              isScrollable: true,
              labelColor: ConvivaColors.pineGreen,
              unselectedLabelColor: ConvivaColors.textSecondary,
              indicatorColor: ConvivaColors.pineGreen,
              tabs: [
                Tab(text: '01 Home'),
                Tab(text: '02 Futuro'),
                Tab(text: '03 Lotado'),
                Tab(text: '04 Realizado'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildImageTab('01-home.png'),
                  _buildImageTab('02-evento-futuro.png'),
                  _buildImageTab('03-evento-lotado.png'),
                  _buildImageTab('04-evento-realizado.png'),
                ],
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        ConvivaState.instance.resetToMockupData();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Dados restaurados para os mockups originais!'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: ConvivaColors.terracotta,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Resetar Dados (Fiel ao Mockup)'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: ConvivaColors.pineGreen,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Fechar Visualizador'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageTab(String path) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          path,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Text('Imagem $path não encontrada.'),
            );
          },
        ),
      ),
    );
  }
}
