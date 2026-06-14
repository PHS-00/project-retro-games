import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegVaultService {
  // Lista em memória para guardar todos os jogos retornados pela API
  List _allGames = [];
  String _searchQuery = "";

  List get jogos => _allGames;
  String get currentSearchQuery => _searchQuery;

  final ValueNotifier tableStateNotifier = ValueNotifier({
    "objects": [],
    "properties": ["title", "genre", "platform"],
    "columns": ["Título", "Gênero", "Plataforma"],
    "total": 0,
    "pageSize": 5,
    "page": 0,
    "pages": 0,
    "cursor": 0
  });

  Future<void> carregarJogos() async {
    var uri = Uri(
      scheme: 'https',
      host: 'api.regvault.org',
      path: '/api/v1/browse',
      queryParameters: {'page': '1', 'limit': '1000'},
    );

    try {
      var jsonString = await http.read(uri);
      var data = jsonDecode(jsonString);

      _allGames = data["games"] ?? [];

      for (var game in _allGames) {
        if (game["genre"] is List) {
          game["genre"] = (game["genre"] as List).join(", ");
        }
      }

      _atualizarEstadoPaginado(0);
    } catch (e) {
      print("Erro ao carregar dados da REG-Vault: $e");
    }
  }

  // Função para atualizar o termo de busca e resetar a paginação
  void buscar(String query) {
    _searchQuery = query.trim().toLowerCase();
    _atualizarEstadoPaginado(0);
  }

  // Função interna responsável por filtrar, fatiar a lista e atualizar o ValueNotifier
  void _atualizarEstadoPaginado(int newCursor) {
    // 1. Aplica o filtro baseado na busca (Varre Título, Sistema e Gênero)
    final filteredGames = _allGames.where((game) {
      final title = (game["title_en"] ?? "").toString().toLowerCase();
      final system = (game["system"] ?? "").toString().toLowerCase();
      final genre = (game["genre"] ?? "").toString().toLowerCase();

      return title.contains(_searchQuery) ||
          system.contains(_searchQuery) ||
          genre.contains(_searchQuery);
    }).toList();

    final int pageSize = tableStateNotifier.value["pageSize"] as int;
    final total = filteredGames.length;

    if (newCursor < 0) newCursor = 0;
    if (newCursor >= total && total > 0) return;

    int end = newCursor + pageSize;
    if (end > total) end = total;

    // Fatiando apenas os itens filtrados
    List pageObjects = total > 0 ? filteredGames.sublist(newCursor, end) : [];

    tableStateNotifier.value = {
      "objects": pageObjects,
      "properties": ["title", "genre", "platform"],
      "columns": ["Título", "Gênero", "Plataforma"],
      "total": total,
      "pageSize": pageSize,
      "page": total > 0 ? (newCursor ~/ pageSize) + 1 : 0,
      "pages": (total / pageSize).ceil(),
      "cursor": newCursor
    };
  }

  void carregarPaginaSeguinte() {
    if (_allGames.isEmpty) return;

    final int pageSize = tableStateNotifier.value["pageSize"] as int;
    final newCursor = tableStateNotifier.value["cursor"] + pageSize;

    _atualizarEstadoPaginado(newCursor);
  }

  void carregarPaginaAnterior() {
    if (_allGames.isEmpty) return;

    final int pageSize = tableStateNotifier.value["pageSize"] as int;
    final newCursor = tableStateNotifier.value["cursor"] - pageSize;

    _atualizarEstadoPaginado(newCursor);
  }
}

final regVaultService = RegVaultService();
