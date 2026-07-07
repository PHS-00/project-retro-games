import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorites_controller.dart';

/// Card unificado para exibição condensada dos dados e mídias de um jogo.
class GameCard extends StatelessWidget {
  final Map game;
  final VoidCallback? onFavorite;
  final VoidCallback? onOpen;
  final bool? isFavorito;

  const GameCard({
    super.key,
    required this.game,
    this.onFavorite,
    this.onOpen,
    this.isFavorito,
  });

  @override
  Widget build(BuildContext context) {
    final favController = Get.find<FavoritesController>();

    // Extração segura dos metadados do mapa do jogo
    final title = game["title_en"] ?? "Sem título";
    final system = game["system"]?.toString() ?? "";
    final year = game["year"] ?? "N/A";
    final publisher = game["publisher"] ?? "N/A";
    final romHash = game["rom_hash"]?.toString() ?? "";

    final genres = (game["genre"] is List)
        ? (game["genre"] as List).join(", ")
        : (game["genre"] ?? "Não informado");

    final hasBoxFront =
        game["has_box_front"] == 1 || game["has_box_front"] == true;

    // Construção direta da URL utilizando a estrutura de pastas do servidor
    final String imageUrl =
        'https://api.regvault.org/assets/images/$system/$romHash/box_front.png';

    return GestureDetector(
      onTap: onOpen,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: const EdgeInsets.all(
              16), // Padding configurado direto no Container do card
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Box delimitado para renderização da imagem ou ícone alternativo
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: (hasBoxFront &&
                            romHash.isNotEmpty &&
                            system.isNotEmpty)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover, // Ajuste de tamanho solicitado
                              errorBuilder: (context, error, stackTrace) {
                                // Evita crash visual em caso de statusCode: 0 ou 404
                                return const Center(
                                  child: Icon(Icons.broken_image,
                                      size: 40, color: Colors.grey),
                                );
                              },
                            ),
                          )
                        : const Icon(Icons.sports_esports, size: 60),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Monitoramento reativo síncrono do GetX para favoritar o jogo
                  Obx(() => IconButton(
                        onPressed: onFavorite,
                        icon: Icon(
                          favController.isFavorito(game)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.redAccent,
                        ),
                      )),
                ],
              ),
              const SizedBox(height: 12),
              Text("Sistema: $system"),
              Text("Ano: $year"),
              Text("Publisher: $publisher"),
              Text("Gêneros: $genres"),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                children: [
                  if (hasBoxFront) const Chip(label: Text("Capa")),
                  if (game["has_screenshot"] == 1 ||
                      game["has_screenshot"] == true)
                    const Chip(label: Text("Screenshot")),
                  if (game["has_manual"] == 1 || game["has_manual"] == true)
                    const Chip(label: Text("Manual")),
                  if (game["has_video_lq"] == 1 ||
                      game["has_video_hq"] == 1 ||
                      game["has_video_lq"] == true ||
                      game["has_video_hq"] == true)
                    const Chip(label: Text("Vídeo")),
                ],
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: onOpen,
                  child: const Text("Ver detalhes"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
