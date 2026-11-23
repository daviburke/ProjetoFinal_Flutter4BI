import 'package:material_ui/material_ui.dart';

import '../data/recipe_api.dart';
import '../models/recipe.dart';

enum Carga { inicial, carregando, pronto, erro }

enum EstadoBusca { parada, carregando, resultados, vazio, erro }

class RecipeStore extends ChangeNotifier {
  RecipeStore(this._api);

  final RecipeApi _api;

  Carga catalogo = Carga.inicial;
  List<Recipe> receitas = const [];
  ApiException? erroCatalogo;

  EstadoBusca estadoBusca = EstadoBusca.parada;
  String consulta = '';
  List<Recipe> resultados = const [];
  ApiException? erroBusca;
  int _tokenBusca = 0;

  final Map<int, Recipe> _favoritos = {};

  List<Recipe> get favoritos => _favoritos.values.toList();

  bool ehFavorito(int id) => _favoritos.containsKey(id);

  void alternarFavorito(Recipe receita) {
    if (_favoritos.remove(receita.id) == null) {
      _favoritos[receita.id] = receita;
    }
    notifyListeners();
  }

  Future<void> carregarReceitas() async {
    if (catalogo == Carga.carregando) return;
    catalogo = Carga.carregando;
    erroCatalogo = null;
    notifyListeners();
    try {
      receitas = await _api.listar();
      catalogo = Carga.pronto;
    } on ApiException catch (e) {
      erroCatalogo = e;
      catalogo = Carga.erro;
    }
    notifyListeners();
  }

  Future<void> pesquisar(String texto) async {
    final termo = texto.trim();
    if (termo.isEmpty || estadoBusca == EstadoBusca.carregando) return;
    final token = ++_tokenBusca;
    consulta = termo;
    erroBusca = null;
    estadoBusca = EstadoBusca.carregando;
    notifyListeners();
    try {
      final encontradas = await _api.pesquisar(termo);
      if (token != _tokenBusca) return;
      resultados = encontradas;
      estadoBusca = encontradas.isEmpty
          ? EstadoBusca.vazio
          : EstadoBusca.resultados;
    } on ApiException catch (e) {
      if (token != _tokenBusca) return;
      erroBusca = e;
      estadoBusca = EstadoBusca.erro;
    }
    notifyListeners();
  }

  void editarBusca() {
    estadoBusca = EstadoBusca.parada;
    notifyListeners();
  }

  void limparBusca() {
    _tokenBusca++;
    consulta = '';
    resultados = const [];
    erroBusca = null;
    estadoBusca = EstadoBusca.parada;
    notifyListeners();
  }
}

class StoreScope extends InheritedNotifier<RecipeStore> {
  const StoreScope({
    super.key,
    required RecipeStore store,
    required super.child,
  }) : super(notifier: store);

  static RecipeStore of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<StoreScope>()!.notifier!;

  static RecipeStore ler(BuildContext context) =>
      context.getInheritedWidgetOfExactType<StoreScope>()!.notifier!;
}
