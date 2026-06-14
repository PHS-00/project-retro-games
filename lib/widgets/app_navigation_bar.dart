import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/data_api_RegVaultService.dart'; // Verifique se o caminho do seu projeto está correto
import 'app_popup_card.dart';

class AppNavigationBar extends StatelessWidget implements PreferredSizeWidget {
  final String pageName;
  final bool showLogo;
  final bool showBackButton;
  final bool showSearchButton;
  final bool enableTransparency;
  final double opacity;
  final Color? backgroundColor;

  const AppNavigationBar({
    super.key,
    required this.pageName,
    this.showLogo = false,
    this.showBackButton = false,
    this.showSearchButton = true,
    this.enableTransparency = false,
    this.opacity = 1.0,
    this.backgroundColor,
  });

  void _openSearch(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // Controlador inicia sempre limpo/vazio para resetar o campo de texto
    final controller = TextEditingController();

    final searchField = TextField(
      controller: controller,
      decoration: const InputDecoration(
        hintText: "Digite o nome, sistema ou gênero",
        border: OutlineInputBorder(),
      ),
    );

    final searchButton = SizedBox(
      height: 45,
      child: TextButton.icon(
        style: TextButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onSurface,
        ),
        onPressed: () {
          final searchText = controller.text;

          // 1. Envia o termo para o serviço (onde o texto será tratado)
          regVaultService.buscar(searchText);

          // 2. Reseta o campo de texto limpando o controlador
          controller.clear();

          // 3. Fecha o modal de pesquisa da tela
          Navigator.pop(context);

          // 4. Se a busca foi feita na Home (ou qualquer rota diferente de /catalogo), redireciona o usuário
          if (Get.currentRoute != '/catalogo') {
            Get.toNamed('/catalogo');
          }
        },
        icon: const Icon(Icons.search, size: 25),
        label: const Text("Buscar"),
      ),
    );

    showDialog(
      context: context,
      builder: (_) => PopupCard(
        title: "Pesquisar",
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxWidth < 600;
            if (isSmallScreen) {
              return Column(
                children: [
                  const SizedBox(height: 14),
                  searchField,
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: searchButton,
                  ),
                ],
              );
            } else {
              return Row(
                children: [
                  Expanded(child: searchField),
                  const SizedBox(width: 12),
                  searchButton,
                ],
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final appBarColor = (backgroundColor ?? colors.surface).withValues(
      alpha: enableTransparency ? opacity : 1.0,
    );

    final isHovering = false.obs;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: enableTransparency
          ? ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 8,
                  sigmaY: 8,
                ),
                child: Container(
                  color: appBarColor,
                ),
              ),
            )
          : Container(
              color: appBarColor,
            ),
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, size: 35),
              onPressed: Get.back,
            )
          : null,
      title: Row(
        children: [
          if (showLogo) ...[
            const Icon(Icons.sports_esports, size: 35),
            const SizedBox(width: 8),
          ],
          Text(
            pageName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        if (showSearchButton)
          MouseRegion(
            onEnter: (_) => isHovering.value = true,
            onExit: (_) => isHovering.value = false,
            child: Obx(
              () => TextButton(
                style: TextButton.styleFrom(
                  iconColor: colors.onSurface,
                  foregroundColor: colors.onSurface,
                ),
                onPressed: () => _openSearch(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      height: 45,
                      width: 75,
                      alignment: Alignment.centerLeft,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 250),
                        opacity: isHovering.value ? 1 : 0,
                        child: const Text("Pesquisar",
                            overflow: TextOverflow.fade),
                      ),
                    ),
                    const Icon(Icons.search, size: 35),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
