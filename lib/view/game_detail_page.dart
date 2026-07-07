import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorites_controller.dart';

/// Modelo isolado para tratamento seguro dos campos do mapa recebido.
class GameModel {
  final String titulo;
  final String sistema;
  final String ano;
  final String publisher;
  final String developer;
  final String pais;
  final String players;
  final String rating;
  final String generos;
  final String romHash;
  final bool temCapa;
  final bool temScreenshot;
  final bool temManual;
  final bool temVideo;

  const GameModel({
    required this.titulo,
    required this.sistema,
    required this.ano,
    required this.publisher,
    required this.developer,
    required this.pais,
    required this.players,
    required this.rating,
    required this.generos,
    required this.romHash,
    required this.temCapa,
    required this.temScreenshot,
    required this.temManual,
    required this.temVideo,
  });

  factory GameModel.fromMap(Map<String, dynamic> map) {
    String processarGeneros(dynamic genre) {
      if (genre is List && genre.isNotEmpty) return genre.join(", ");
      if (genre is String && genre.isNotEmpty) return genre;
      return "Não informado";
    }

    return GameModel(
      titulo: map["title_en"] ?? "Sem título",
      sistema: map["system"] ?? "N/A",
      ano: map["year"]?.toString() ?? "N/A",
      publisher: map["publisher"] ?? "N/A",
      developer: map["developer"] ?? "N/A",
      pais: map["country"] ?? map["region"] ?? "N/A",
      players:
          map["players_max"]?.toString() ?? map["players"]?.toString() ?? "N/A",
      rating: map["rating"] ?? "N/A",
      generos: processarGeneros(map["genre"]),
      romHash: map["rom_hash"]?.toString() ?? "",
      temCapa: map["has_box_front"] == 1 || map["has_box_front"] == true,
      temScreenshot:
          map["has_screenshot"] == 1 || map["has_screenshot"] == true,
      temManual: map["has_manual"] == 1 || map["has_manual"] == true,
      temVideo: map["has_video_lq"] == 1 ||
          map["has_video_hq"] == 1 ||
          map["has_video_lq"] == true ||
          map["has_video_hq"] == true,
    );
  }
}

/// Página de Detalhes do Jogo — 100% Stateless e simplificada.
class GameDetailPage extends StatelessWidget {
  const GameDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoritesController favController = Get.find<FavoritesController>();

    // Captura dos argumentos repassados na rota de navegação do GetX
    final Map<String, dynamic> argumentos =
        (Get.arguments as Map<String, dynamic>?) ?? {};
    final jogo = GameModel.fromMap(argumentos);

    // Links estáticos montados diretamente em conformidade com o seu padrão de pastas da API
    final String coverUrl =
        'https://api.regvault.org/assets/images/${jogo.sistema}/${jogo.romHash}/box_front.png';
    final String screenshotUrl =
        'https://api.regvault.org/assets/images/${jogo.sistema}/${jogo.romHash}/screenshot.png';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar superior com efeito de colapso integrada à imagem
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: Colors.deepPurple.shade900,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                jogo.titulo,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 6, color: Colors.black)],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.deepPurple.shade800, Colors.grey.shade900],
                  ),
                ),
                child: (jogo.temCapa && jogo.romHash.isNotEmpty)
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            coverUrl,
                            fit: BoxFit.cover, // Ajuste de exibição da imagem
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(Icons.broken_image,
                                    size: 72, color: Colors.white30),
                              );
                            },
                          ),
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.75)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const Center(
                        child: Icon(Icons.sports_esports,
                            size: 72, color: Colors.white30)),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => Get.back(),
            ),
            actions: [
              // Observável do GetX gerenciando a cor do coração reativamente
              Obx(() {
                final isFav = favController.isFavorito(argumentos);
                return IconButton(
                  tooltip: isFav ? "Remover dos favoritos" : "Favoritar",
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red.shade400 : Colors.white,
                    size: 28,
                  ),
                  onPressed: () => favController.toggleFavorito(argumentos),
                );
              }),
            ],
          ),

          // Corpo principal de especificações
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(
                  20), // Padding padronizado no Container estrutural
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      if (jogo.temCapa)
                        const _MidiaChip(
                            label: "Capa",
                            icon: Icons.image,
                            color: Colors.indigo),
                      if (jogo.temScreenshot)
                        const _MidiaChip(
                            label: "Screenshot",
                            icon: Icons.screenshot_monitor,
                            color: Colors.teal),
                      if (jogo.temManual)
                        const _MidiaChip(
                            label: "Manual",
                            icon: Icons.menu_book,
                            color: Colors.orange),
                      if (jogo.temVideo)
                        const _MidiaChip(
                            label: "Vídeo",
                            icon: Icons.play_circle,
                            color: Colors.red),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _SectionCard(
                    titulo: "Informações",
                    icon: Icons.info_outline,
                    child: Column(
                      children: [
                        _InfoRow(
                            icon: Icons.computer,
                            label: "Sistema",
                            valor: jogo.sistema),
                        _InfoRow(
                            icon: Icons.calendar_month,
                            label: "Ano",
                            valor: jogo.ano),
                        _InfoRow(
                            icon: Icons.category,
                            label: "Gênero",
                            valor: jogo.generos),
                        _InfoRow(
                            icon: Icons.flag, label: "País", valor: jogo.pais),
                        _InfoRow(
                            icon: Icons.people,
                            label: "Jogadores",
                            valor: jogo.players),
                        _InfoRow(
                            icon: Icons.star_outline,
                            label: "Rating",
                            valor: jogo.rating,
                            isLast: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SectionCard(
                    titulo: "Publicação",
                    icon: Icons.business,
                    child: Column(
                      children: [
                        _InfoRow(
                            icon: Icons.business,
                            label: "Publisher",
                            valor: jogo.publisher),
                        _InfoRow(
                            icon: Icons.code,
                            label: "Developer",
                            valor: jogo.developer,
                            isLast: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Bloco simplificado com renderização direta da Screenshot
                  if (jogo.temScreenshot && jogo.romHash.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.screenshot_monitor,
                                color: Colors.deepPurple.shade300, size: 20),
                            const SizedBox(width: 8),
                            const Text("Screenshots",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 160,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              screenshotUrl,
                              height: 160,
                              fit: BoxFit.cover, // Ajuste de tamanho solicitado
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(Icons.broken_image,
                                      size: 50, color: Colors.grey),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Sub-widgets auxiliares mantidos estritamente como Stateless internos
class _MidiaChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _MidiaChip(
      {required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 16, color: color.withValues(alpha: 0.9)),
      label: Text(label,
          style: const TextStyle(color: Colors.white70, fontSize: 12)),
      backgroundColor: color.withValues(alpha: 0.2),
      side: BorderSide(color: color.withValues(alpha: 0.5)),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String titulo;
  final IconData icon;
  final Widget child;

  const _SectionCard(
      {required this.titulo, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.deepPurple.shade700, width: 1),
      ),
      child: Container(
        padding: const EdgeInsets.all(16), // Padding unificado via Container
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.deepPurple.shade300, size: 20),
                const SizedBox(width: 8),
                Text(titulo,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(height: 1, color: Colors.white12),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String valor;
  final bool isLast;

  const _InfoRow(
      {required this.icon,
      required this.label,
      required this.valor,
      this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
              vertical: 6), // Container controlando o espaçamento vertical
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 18, color: Colors.deepPurple.shade300),
              const SizedBox(width: 10),
              SizedBox(
                width: 90,
                child: Text(
                  label,
                  style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                child: Text(valor,
                    style: const TextStyle(color: Colors.white, fontSize: 13)),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1, color: Colors.white10),
      ],
    );
  }
}
