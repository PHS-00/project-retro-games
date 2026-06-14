import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'view/home_page.dart';
import 'view/catalog_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'App-name',
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
        scaffoldBackgroundColor: Colors.grey,
        // appBarTheme: const AppBarTheme(
        //   backgroundColor: Colors.black,
        //   foregroundColor: Colors.white,
        //   elevation: 0,
        //   centerTitle: true,
        // ),
        // cardTheme: const CardThemeData(
        //   color: Colors.black87,
        // ),
        // inputDecorationTheme: InputDecorationTheme(
        //   border: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(12),
        //   ),
        // ),
      ),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const HomePage(),
        ),
        GetPage(
          name: '/catalogo',
          page: () => CatalogPage(),
        ),
      ],
    );
  }
}
