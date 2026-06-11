import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/app_navigation_bar.dart';
import '../widgets/app_floating_button.dart';
import '../widgets/app_footer.dart';
import '../widgets/app_action_chip.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppNavigationBar(
        pageName: "Home",
      ),
      floatingActionButton: AppFloatingButton(
        label: "Catálogo",
        icon: Icons.sports_esports,
        onPressed: () {
          Get.toNamed('/catalogo');
        },
      ),
      body: Stack(
        children: [
          // Imagem de fundo
          Positioned.fill(
            child: Image.asset(
              'assets/images/thumb-1920-1364875.png',
              fit: BoxFit.cover,
            ),
          ),

          // Overlay escuro para melhorar a leitura
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.6),
            ),
          ),

          // Conteúdo da página
          SingleChildScrollView(
            child: Column(
              children: [
                // CONTEÚDO PRINCIPAL
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        const Icon(
                          Icons.sports_esports,
                          size: 100,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "App-name",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Explore milhares de jogos retrô de diversas plataformas utilizando a API REG-Vault.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 15,
                          runSpacing: 15,
                          children: [
                            AppActionChip(
                              icon: Icons.videogame_asset,
                              label: "91.000+ Jogos",
                              onTap: () {
                                Get.toNamed('/catalogo');
                              },
                            ),
                            const AppActionChip(
                              icon: Icons.computer,
                              label: "Múltiplos Sistemas",
                            ),
                          ],
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),

                // FOOTER
                AppFooter(
                  appName: "App-name",
                  version: "1.0.0",
                  apiName: "REG-Vault",
                  year: "2026",
                  description:
                      "Catálogo digital de jogos retrô desenvolvido em Flutter para consulta de metadados de milhares de jogos clássicos.",
                  technologyChips: [
                    const AppActionChip(
                      icon: Icons.flutter_dash,
                      label: "Flutter",
                      url: "https://flutter.dev",
                    ),
                    const AppActionChip(
                      icon: Icons.storage,
                      label: "REG-Vault",
                      url: "https://api.regvault.org",
                    ),
                    const AppActionChip(
                      icon: Icons.code,
                      label: "GetX",
                    ),
                  ],
                  developerChips: [
                    const AppActionChip(
                      icon: Icons.person,
                      label: "Jezreel",
                    ),
                    const AppActionChip(
                      icon: Icons.person,
                      label: "Pedro Henrique da Silva",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
