import 'package:material_ui/material_ui.dart';

import 'app.dart';
import 'data/recipe_api.dart';
import 'state/recipe_store.dart';

void main() {
  final store = RecipeStore(RecipeApi())..carregarReceitas();
  runApp(StoreScope(store: store, child: const SaboreApp()));
}
