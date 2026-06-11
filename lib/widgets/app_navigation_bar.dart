import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppNavigationBar extends StatelessWidget implements PreferredSizeWidget {
  final String pageName;
  final bool showBrand;
  final bool showBackButton;

  const AppNavigationBar({
    super.key,
    required this.pageName,
    this.showBrand = true,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Get.back();
              },
            )
          : null,
      title: Row(
        children: [
          if (showBrand) ...[
            const Icon(Icons.sports_esports, size: 30),
            const SizedBox(width: 10),
            const Text(
              "App-name",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("Buscar"),
                content: SizedBox(
                  width: 500,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Digite o nome do jogo",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Fechar"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Buscar"),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
