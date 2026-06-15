import 'package:get/get.dart';

class FavoritesController extends GetxController {
  final RxList favoritos = [].obs;

  bool isFavorito(Map jogo) {
    return favoritos.any((f) => f["slug"] == jogo["slug"]); // corrigido
  }

  void toggleFavorito(Map jogo) {
    if (isFavorito(jogo)) {
      favoritos.removeWhere((f) => f["slug"] == jogo["slug"]); // corrigido
    } else {
      favoritos.add(jogo);
    }
  }
}
