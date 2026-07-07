import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'view/home_page.dart';
import 'view/catalog_page.dart';
import 'view/favorites_page.dart';
import 'view/game_detail_page.dart';
import 'controllers/favorites_controller.dart';

void main() {
  Get.put(FavoritesController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Retolog',
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Colors.purple,
          secondary: Colors.green,
          surface: Colors.black,
          outline: Colors.grey,
          onSurface: Colors.white,
          error: Colors.red,
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.black,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const HomePage()),
        GetPage(name: '/catalogo', page: () => const CatalogPage()),
        GetPage(name: '/favoritos', page: () => const FavoritesPage()),
        GetPage(name: '/detalhe', page: () => const GameDetailPage()),
      ],
    );
  }
}
