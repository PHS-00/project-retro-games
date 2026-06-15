import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorites_controller.dart';
import '../data/data_api_RegVaultService.dart';

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
              Row(
                children: [
                  _GameCover(
                    system: system,
                    romHash: romHash,
                    hasBoxFront: hasBoxFront,
                    size: 60,
                  ),
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

class _GameCover extends StatefulWidget {
  final String system;
  final String romHash;
  final bool hasBoxFront;
  final double size;

  const _GameCover({
    required this.system,
    required this.romHash,
    required this.hasBoxFront,
    required this.size,
  });

  @override
  State<_GameCover> createState() => _GameCoverState();
}

class _GameCoverState extends State<_GameCover> {
  String? _imageUrl;
  bool _erro = false;

  @override
  void initState() {
    super.initState();
    if (widget.hasBoxFront &&
        widget.romHash.isNotEmpty &&
        widget.system.isNotEmpty) {
      _carregarUrl();
    }
  }

  Future<void> _carregarUrl() async {
    final dados = await regVaultService.carregarDetalhesJogo(
      widget.system,
      widget.romHash,
    );
    if (!mounted) return;

    final assets = dados?["assets"] as Map<String, dynamic>?;
    final path = assets?["box_front"]?.toString();

    if (path != null && path.isNotEmpty) {
      setState(() => _imageUrl = 'https://api.regvault.org$path');
    } else {
      setState(() => _erro = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.hasBoxFront ||
        widget.romHash.isEmpty ||
        widget.system.isEmpty ||
        _erro) {
      return Icon(Icons.sports_esports, size: widget.size);
    }

    if (_imageUrl == null) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.network(
        _imageUrl!,
        width: widget.size,
        height: widget.size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            Icon(Icons.sports_esports, size: widget.size),
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return SizedBox(
            width: widget.size,
            height: widget.size,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
      ),
    );
  }
}
