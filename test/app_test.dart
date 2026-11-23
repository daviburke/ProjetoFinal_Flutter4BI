import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:projetofinal_4bi/app.dart';
import 'package:projetofinal_4bi/data/recipe_api.dart';
import 'package:projetofinal_4bi/state/recipe_store.dart';
import 'package:projetofinal_4bi/widgets/cartao_receita.dart';

const _pizza = {
  'id': 1,
  'name': 'Classic Margherita Pizza',
  'ingredients': ['Pizza dough', 'Tomato sauce', 'Fresh mozzarella'],
  'instructions': ['Preheat the oven to 475°F.', 'Bake for 12 minutes.'],
  'prepTimeMinutes': 20,
  'cookTimeMinutes': 15,
  'servings': 4,
  'difficulty': 'Easy',
  'cuisine': 'Italian',
  'rating': 4.6,
  'mealType': ['Dinner'],
};

http.Response _json(Object corpo, [int status = 200]) => http.Response.bytes(
  utf8.encode(jsonEncode(corpo)),
  status,
  headers: {'content-type': 'application/json; charset=utf-8'},
);

Future<List<String>> _abrir(
  WidgetTester tester, {
  bool listaFalha = false,
}) async {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 2.6;
  addTearDown(tester.view.reset);

  final consultas = <String>[];
  var falhar = listaFalha;
  final cliente = MockClient((req) async {
    if (req.url.path == '/recipes') {
      if (falhar) {
        falhar = false;
        throw http.ClientException('sem rede');
      }
      return _json({
        'recipes': [_pizza],
      });
    }
    final q = req.url.queryParameters['q'] ?? '';
    consultas.add(q);
    if (q == 'erro') return _json({'message': 'falha'}, 500);
    if (q == 'formato') return http.Response('<html>', 200);
    return _json({
      'recipes': q.toLowerCase().contains('pizza') ? [_pizza] : [],
    });
  });

  final store = RecipeStore(RecipeApi(client: cliente))..carregarReceitas();
  await tester.pumpWidget(StoreScope(store: store, child: const SaboreApp()));
  await tester.pump();
  await tester.pump();
  return consultas;
}

Future<void> _pesquisar(WidgetTester tester, String texto) async {
  await tester.enterText(find.byType(TextField), texto);
  await tester.tap(find.text('Pesquisar'));
  await tester.pump();
  await tester.pump();
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('carrega a lista e abre o detalhe', (tester) async {
    await _abrir(tester);
    await tester.pumpAndSettle();

    expect(find.text('Receitas disponíveis'), findsOneWidget);
    await tester.tap(find.text('Classic Margherita Pizza'));
    await tester.pumpAndSettle();

    expect(find.text('Receita'), findsOneWidget);
    expect(find.text('Italian  •  Fácil  •  4,6 / 5'), findsOneWidget);
    expect(find.text('35 min'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Bake for 12 minutes.'), 200);
    expect(find.text('Fresh mozzarella'), findsOneWidget);

    await tester.tap(find.byTooltip('Voltar'));
    await tester.pumpAndSettle();
    expect(find.text('Receitas disponíveis'), findsOneWidget);
  });

  testWidgets('falha de rede mostra erro e tenta de novo', (tester) async {
    await _abrir(tester, listaFalha: true);
    await tester.pumpAndSettle();

    expect(find.text('Não foi possível carregar as receitas.'), findsOneWidget);
    expect(
      find.text('Verifique sua conexão e tente novamente.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Tentar novamente'));
    await tester.pump();
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.text('Classic Margherita Pizza'), findsOneWidget);
  });

  testWidgets('pesquisa recusa vazio, remove espaços e mantém contexto', (
    tester,
  ) async {
    final consultas = await _abrir(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Buscar receitas'));
    await tester.pumpAndSettle();
    expect(find.text('Qual receita você procura?'), findsOneWidget);

    await _pesquisar(tester, '   ');
    expect(find.text('Digite um nome para pesquisar.'), findsOneWidget);
    expect(consultas, isEmpty);

    await _pesquisar(tester, '  Pizza  ');
    expect(consultas, ['Pizza']);
    expect(find.text('Resultados para “Pizza”'), findsOneWidget);

    await tester.tap(find.text('Classic Margherita Pizza'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Voltar'));
    await tester.pumpAndSettle();
    expect(find.text('Resultados para “Pizza”'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Limpar pesquisa'),
      200,
      scrollable: find
          .descendant(
            of: find.byType(ListView),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.tap(find.text('Limpar pesquisa'));
    await tester.pumpAndSettle();
    expect(find.text('Qual receita você procura?'), findsOneWidget);
  });

  testWidgets('sem resultado é diferente de erro', (tester) async {
    await _abrir(tester);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Buscar receitas'));
    await tester.pumpAndSettle();

    await _pesquisar(tester, 'zzzz987');
    expect(find.text('Nenhum resultado'), findsOneWidget);

    await tester.tap(find.text('Alterar pesquisa'));
    await tester.pumpAndSettle();
    await _pesquisar(tester, 'erro');
    expect(find.text('Não foi possível pesquisar.'), findsOneWidget);
    expect(find.text('Nenhum resultado'), findsNothing);

    await tester.tap(find.text('Alterar pesquisa'));
    await tester.pumpAndSettle();
    await _pesquisar(tester, 'formato');
    expect(
      find.text('Recebemos dados em um formato inesperado. Tente novamente.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Alterar pesquisa'));
    await tester.pumpAndSettle();
    await _pesquisar(tester, 'zzzz987');
    await tester.tap(find.text('Ver todas as receitas'));
    await tester.pumpAndSettle();
    expect(find.text('Receitas disponíveis'), findsOneWidget);
  });

  testWidgets('favoritos sem duplicata e remoção', (tester) async {
    await _abrir(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Favoritos'));
    await tester.pumpAndSettle();
    expect(find.text('Nenhum favorito'), findsOneWidget);
    await tester.tap(find.text('Explorar receitas'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.favorite_border).first);
    await tester.pump();
    await tester.tap(find.text('Classic Margherita Pizza'));
    await tester.pumpAndSettle();
    expect(find.text('Salva'), findsOneWidget);
    await tester.tap(find.byTooltip('Voltar'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Favoritos'));
    await tester.pumpAndSettle();
    expect(find.text('Receitas salvas nesta sessão.'), findsOneWidget);
    expect(find.text('Classic Margherita Pizza'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(CartaoReceita),
        matching: find.byIcon(Icons.favorite),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Nenhum favorito'), findsOneWidget);
  });
}
