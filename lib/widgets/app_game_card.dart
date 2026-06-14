import 'package:flutter/material.dart';
// import 'package:get/get.dart';

class GameCard extends StatelessWidget {
  final Map game;
  final VoidCallback? onFavorite;
  final VoidCallback? onOpen;

  const GameCard({
    super.key,
    required this.game,
    this.onFavorite,
    this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    // final colors = Theme.of(context).colorScheme;

    final title = game["title_en"] ?? "Sem título";
    final system = game["system"] ?? "N/A";
    final year = game["year"] ?? "N/A";
    final publisher = game["publisher"] ?? "N/A";

    final genres = (game["genre"] is List)
        ? (game["genre"] as List).join(", ")
        : (game["genre"] ?? "Não informado");

    return GestureDetector(
      onTap: onOpen,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================
              // HEADER
              // =========================
              Row(
                children: [
                  const Icon(Icons.sports_esports, size: 40),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: onFavorite,
                    icon: const Icon(
                      Icons.favorite_border,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // =========================
              // INFO
              // =========================
              Text("Sistema: $system"),
              Text("Ano: $year"),
              Text("Publisher: $publisher"),
              Text("Gêneros: $genres"),

              const SizedBox(height: 10),

              // =========================
              // FEATURES (chips da API)
              // =========================
              Wrap(
                spacing: 6,
                children: [
                  if (game["has_box_front"] == 1)
                    const Chip(label: Text("Capa")),
                  if (game["has_screenshot"] == 1)
                    const Chip(label: Text("Screenshot")),
                  if (game["has_manual"] == 1)
                    const Chip(label: Text("Manual")),
                  if (game["has_video_lq"] == 1 || game["has_video_hq"] == 1)
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
