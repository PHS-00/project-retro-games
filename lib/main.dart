import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'view/home_page.dart';
// import 'view/catalog_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'RetroVault',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[900],
      ),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const HomePage(),
        ),
        // GetPage(
        //   name: '/catalogo',
        //   page: () => const CatalogPage(),
        // ),
      ],
    );
  }
}
