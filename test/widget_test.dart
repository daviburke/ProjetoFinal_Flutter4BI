import 'package:flutter_test/flutter_test.dart';
import 'package:projetofinal_4bi/models/recipe.dart';

void main() {
  test('tempo total só aparece com preparo e cozimento', () {
    final completa = Recipe.tryParse({
      'id': 1,
      'name': 'Pizza',
      'prepTimeMinutes': 15,
      'cookTimeMinutes': 20,
      'rating': 5,
      'mealType': 'Dinner',
    })!;
    expect(completa.tempo?.valor, '35 min');
    expect(completa.nota, '5,0 / 5');
    expect(completa.mealTypes, ['Dinner']);

    final parcial = Recipe.tryParse({'id': 2, 'prepTimeMinutes': 10})!;
    expect(parcial.tempo?.legenda, 'preparo');
    expect(parcial.name, 'Receita sem nome');
  });

  test('ignora item sem id', () {
    expect(Recipe.tryParse({'name': 'Sem id'}), isNull);
  });
}
