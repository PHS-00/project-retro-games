import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/data_api_RegVaultService.dart';
import '../widgets/app_navigation_bar.dart';
import '../widgets/app_floating_button.dart';
import '../widgets/app_game_card.dart';

class CatalogPage extends StatelessWidget {
  CatalogPage({super.key});

  final service = regVaultService;

  void _load() {
    // CORRIGIDO: Só chama a API se a lista global estiver limpa, prevenindo loops infinitos.
    if (service.jogos.isEmpty) {
      Future.microtask(() => service.carregarJogos());
    }
  }

  @override
  Widget build(BuildContext context) {
    _load();
    final colors = Theme.of(context).colorScheme;

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
            onPressed: () {},
          ),
          const SizedBox(height: 35),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: service.tableStateNotifier,
        builder: (context, state, _) {
          // CORRIGIDO: Coletando os objetos fatiados/filtrados da página atual
          final games = state["objects"] as List;
          final currentPage = state["page"] as int;
          final totalPages = state["pages"] as int;

          // Se a lista mestre está vazia e está carregando
          if (games.isEmpty && service.jogos.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Se a busca não retornou nenhum registro
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
              // Lista de cards dinâmica
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: games.length,
                  itemBuilder: (context, index) {
                    final game = games[index];

                    return GameCard(
                      game: game,
                      onFavorite: () {
                        print("Favoritou: ${game["title_en"]}");
                      },
                      onOpen: () {
                        Get.toNamed('/detalhe', arguments: game);
                      },
                    );
                  },
                ),
              ),

              // CORRIGIDO: Adicionado controle visual de paginação integrado ao ValueNotifier
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: colors.surface.withOpacity(0.2),
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
