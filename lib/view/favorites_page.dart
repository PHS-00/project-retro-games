import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/data_api_RegVaultService.dart';
import '../controllers/favorites_controller.dart';
import '../widgets/app_navigation_bar.dart';
import '../widgets/app_game_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final FavoritesController favController = Get.find<FavoritesController>();

    return Scaffold(
      appBar: const AppNavigationBar(
        pageName: "Favoritos",
        showBackButton: true,
        showSearchButton: false,
      ),
      body: Obx(() {
        if (favController.favoritos.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 80,
                  color: colors.primary,
                ),
                const SizedBox(height: 20),
                Text(
                  "Nenhum favorito ainda",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Explore o catálogo e favorite seus jogos!",
                  style: TextStyle(
                      color: colors.onSurface.withValues(alpha: 0.5),
                      fontSize: 14),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Get.toNamed('/catalogo');
                    regVaultService.carregarJogos();
                  },
                  icon: const Icon(Icons.sports_esports),
                  label: const Text("Ir ao Catálogo"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onSurface,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Row(
                children: [
                  Icon(Icons.favorite, color: colors.error, size: 20),
                  const SizedBox(width: 8),
                  Obx(() => Text(
                        "${favController.favoritos.length} jogo(s) favorito(s)",
                        style: TextStyle(
                          color: colors.onSurface.withValues(alpha: 0.5),
                          fontSize: 14,
                        ),
                      )),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: favController.favoritos.length,
                itemBuilder: (context, index) {
                  final jogo = favController.favoritos[index];
                  return GameCard(
                    game: jogo,
                    onFavorite: () => favController.toggleFavorito(jogo),
                    isFavorito: favController.isFavorito(jogo),
                    onOpen: () => Get.toNamed('/detalhe', arguments: jogo),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
