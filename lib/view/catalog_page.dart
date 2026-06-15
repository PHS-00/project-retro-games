import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/data_api_RegVaultService.dart';
import '../controllers/favorites_controller.dart';
import '../widgets/app_navigation_bar.dart';
import '../widgets/app_floating_button.dart';
import '../widgets/app_game_card.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final service = regVaultService;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  @override
  void dispose() {
    service.buscar("");
    super.dispose();
  }

  Future<void> _carregarDados() async {
    if (service.jogos.isEmpty) {
      await service.carregarJogos();

      service.jogos.sort((a, b) {
        int scoreA = (a["has_box_front"] ?? 0) + (a["has_screenshot"] ?? 0);
        int scoreB = (b["has_box_front"] ?? 0) + (b["has_screenshot"] ?? 0);
        return scoreB.compareTo(scoreA);
      });

      service.buscar("");
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final favController = Get.find<FavoritesController>();

    return Scaffold(
      appBar: const AppNavigationBar(
        pageName: "Catálogo",
        showBackButton: true,
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AppFloatingButton(
            icon: Icons.favorite,
            label: 'Favoritos',
            onPressed: () => Get.toNamed('/favoritos'),
          ),
          const SizedBox(height: 35),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: service.tableStateNotifier,
        builder: (context, state, _) {
          final games = state["objects"] as List;
          final currentPage = state["page"] as int;
          final totalPages = state["pages"] as int;

          if (games.isEmpty && service.jogos.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (games.isEmpty) {
            return const Center(
              child: Text(
                "Nenhum jogo encontrado para esta pesquisa.",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: games.length,
                  itemBuilder: (context, index) {
                    final game = games[index];
                    return GameCard(
                      game: game,
                      onFavorite: () => favController.toggleFavorito(game),
                      onOpen: () => Get.toNamed('/detalhe', arguments: game),
                    );
                  },
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: colors.surface.withValues(alpha: 0.2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: currentPage > 1
                          ? service.carregarPaginaAnterior
                          : null,
                      icon: const Icon(Icons.arrow_back_ios, size: 16),
                      label: const Text("Anterior"),
                    ),
                    Text(
                      "Página $currentPage de $totalPages",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextButton.icon(
                      onPressed: currentPage < totalPages
                          ? service.carregarPaginaSeguinte
                          : null,
                      icon: const Text("Próxima"),
                      label: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
