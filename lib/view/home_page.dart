import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/data_api_RegVaultService.dart';
import '../widgets/app_navigation_bar.dart';
import '../widgets/app_floating_button.dart';
import '../widgets/app_footer.dart';
import '../widgets/app_action_chip.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Tema atual da aplicação.
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppNavigationBar(
        pageName: "Home",
        showLogo: true,
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AppFloatingButton(
            icon: Icons.favorite,
            label: 'Favoritos',
            onPressed: () {
              Get.toNamed('/favoritos');
            },
          ),
          const SizedBox(height: 10),
          AppFloatingButton(
            icon: Icons.library_books,
            label: 'Catálogo',
            onPressed: () {
              Get.toNamed('/catalogo');
              regVaultService.carregarJogos();
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/thumb-1920-1364875.png',
            fit: BoxFit.cover,
          ),
          Container(
            color: colors.surface.withOpacity(0.5),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(30),
                  color: colors.surface.withOpacity(0.5),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Icon(
                        Icons.sports_esports,
                        size: 100,
                        color: colors.onSurface,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Retolog",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Explore milhares de jogos retrô utilizando a API REG-Vault.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: colors.onSurface.withOpacity(.8),
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
                            // onTap: () => Get.toNamed('/catalogo'),
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
                AppFooter(
                  appName: "Retolog",
                  version: "1.0.0",
                  apiName: "REG-Vault",
                  year: "2026",
                  description:
                      "Catálogo digital de jogos retrô desenvolvido em Flutter.",
                  technologyChips: [
                    const AppActionChip(
                      icon: Icons.flutter_dash,
                      label: "Flutter",
                      url: "https://flutter.dev",
                      backgroundColor: Colors.lightBlue,
                    ),
                    const AppActionChip(
                      icon: Icons.storage,
                      label: "REG-Vault",
                      url: "https://regvault.org",
                      backgroundColor: Colors.purple,
                    ),
                    const AppActionChip(
                      icon: Icons.code,
                      label: "GetX",
                      backgroundColor: Colors.green,
                    ),
                  ],
                  developerChips: [
                    const AppActionChip(
                      icon: Icons.person,
                      label: "Jezreel",
                    ),
                    const AppActionChip(
                      icon: Icons.person,
                      label: "Pedro",
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
