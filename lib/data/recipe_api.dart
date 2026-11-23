import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/recipe.dart';

enum TipoErro { rede, servidor, formato }

class ApiException implements Exception {
  const ApiException(this.tipo);

  final TipoErro tipo;

  String get mensagem {
    switch (tipo) {
      case TipoErro.rede:
        return 'Verifique sua conexão e tente novamente.';
      case TipoErro.servidor:
        return 'O servidor não respondeu como esperado. Tente novamente.';
      case TipoErro.formato:
        return 'Recebemos dados em um formato inesperado. Tente novamente.';
    }
  }
}

class RecipeApi {
  RecipeApi({http.Client? client}) : _client = client ?? http.Client();

  static const _host = 'dummyjson.com';

  final http.Client _client;

  Future<List<Recipe>> listar() =>
      _buscar(Uri.https(_host, '/recipes', {'limit': '50'}));

  Future<List<Recipe>> pesquisar(String termo) =>
      _buscar(Uri.https(_host, '/recipes/search', {'q': termo, 'limit': '50'}));

  Future<List<Recipe>> _buscar(Uri uri) async {
    final http.Response resposta;
    try {
      resposta = await _client.get(uri).timeout(const Duration(seconds: 15));
    } on Exception {
      throw const ApiException(TipoErro.rede);
    }

    if (resposta.statusCode != 200) {
      throw const ApiException(TipoErro.servidor);
    }

    final Object? corpo;
    try {
      corpo = jsonDecode(utf8.decode(resposta.bodyBytes));
    } on FormatException {
      throw const ApiException(TipoErro.formato);
    }

    if (corpo is! Map || corpo['recipes'] is! List) {
      throw const ApiException(TipoErro.formato);
    }

    return (corpo['recipes'] as List)
        .map(Recipe.tryParse)
        .whereType<Recipe>()
        .toList();
  }
}
