import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegVaultService {
  List _currentGames = [];
  String _searchQuery = "";
  int _currentPage = 1;
  int _totalJogos = 0;
  static const int _limite = 100;

  final Map<String, Map<String, dynamic>> _cache = {};

  List get jogos => _currentGames;
  String get currentSearchQuery => _searchQuery;
  int get totalJogos => _totalJogos;
  int get currentPage => _currentPage;
  int get totalPages => (_totalJogos / _limite).ceil();

  final ValueNotifier tableStateNotifier = ValueNotifier({
    "objects": [],
    "properties": ["title", "genre", "platform"],
    "columns": ["Título", "Gênero", "Plataforma"],
    "total": 0,
    "pageSize": _limite,
    "page": 0,
    "pages": 0,
  });

  Future<void> carregarPagina(int pagina) async {
    print("Carregando página $pagina...");

    final queryParams = {
      'page': pagina.toString(),
      'limit': '$_limite',
      if (_searchQuery.isNotEmpty) 'q': _searchQuery,
    };

    var uri = Uri(
      scheme: 'https',
      host: 'api.regvault.org',
      path: '/api/v1/browse',
      queryParameters: queryParams,
    );

    try {
      var jsonString = await http.read(uri);
      var data = jsonDecode(jsonString);

      _totalJogos = data["total"] ?? 0;
      _currentPage = pagina;

      final jogos = (data["games"] ?? []) as List;
      _currentGames = jogos;

      print(
          "Página $pagina carregada — ${jogos.length} jogos | Total: $_totalJogos");

      tableStateNotifier.value = {
        "objects": _currentGames,
        "properties": ["title", "genre", "platform"],
        "columns": ["Título", "Gênero", "Plataforma"],
        "total": _totalJogos,
        "pageSize": _limite,
        "page": _currentPage,
        "pages": totalPages,
      };
    } catch (e) {
      print("Erro ao carregar página $pagina: $e");
    }
  }

  Future<void> carregarJogos() async {
    _searchQuery = "";
    _currentPage = 1;
    await carregarPagina(1);
  }

  Future<void> buscar(String query) async {
    _searchQuery = query.trim().toLowerCase();
    _currentPage = 1;
    await carregarPagina(1);
  }

  Future<void> carregarPaginaSeguinte() async {
    if (_currentPage < totalPages) {
      await carregarPagina(_currentPage + 1);
    }
  }

  Future<void> carregarPaginaAnterior() async {
    if (_currentPage > 1) {
      await carregarPagina(_currentPage - 1);
    }
  }

  Future<Map<String, dynamic>?> carregarDetalhesJogo(
      String system, String romHash) async {
    final key = '$system/$romHash';
    if (_cache.containsKey(key)) return _cache[key];

    var uri = Uri(
      scheme: 'https',
      host: 'api.regvault.org',
      path: '/api/v1/game/$system/$romHash',
    );

    try {
      var jsonString = await http.read(uri);
      final dados = jsonDecode(jsonString) as Map<String, dynamic>;
      _cache[key] = dados;
      return dados;
    } catch (e) {
      print("Erro ao carregar detalhes $system/$romHash: $e");
      return null;
    }
  }
}

final regVaultService = RegVaultService();
