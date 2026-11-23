import 'package:material_ui/material_ui.dart';

import '../models/recipe.dart';
import '../state/recipe_store.dart';
import '../theme.dart';
import '../widgets/cabecalho.dart';
import '../widgets/imagem_receita.dart';

Route<void>? _detalheAberto;

void abrirDetalhe(BuildContext context, Recipe receita) {
  if (_detalheAberto?.isActive ?? false) return;
  final rota = MaterialPageRoute<void>(
    builder: (_) => DetalheScreen(receita: receita),
  );
  _detalheAberto = rota;
  Navigator.of(context, rootNavigator: true).push(rota);
}

class DetalheScreen extends StatelessWidget {
  const DetalheScreen({super.key, required this.receita});

  final Recipe receita;

  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    final favorita = store.ehFavorito(receita.id);
    final meta = [
      receita.cuisine,
      receita.difficulty,
      receita.nota,
    ].whereType<String>().join('  •  ');
    final tempo = receita.tempo;

    final chips = <Widget>[
      if (tempo != null) _Dado(valor: tempo.valor, legenda: tempo.legenda),
      if (receita.servings != null)
        _Dado(valor: '${receita.servings}', legenda: 'porções'),
      _Dado(
        valor: favorita ? 'Salva' : 'Salvar',
        legenda: favorita ? 'nos favoritos' : 'toque no coração',
      ),
    ];

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            CabecalhoVoltar(
              titulo: 'Receita',
              aoVoltar: () => Navigator.of(context).maybePop(),
              acao: IconButton(
                onPressed: () => store.alternarFavorito(receita),
                tooltip: favorita
                    ? 'Remover dos favoritos'
                    : 'Adicionar aos favoritos',
                icon: Icon(
                  favorita ? Icons.favorite : Icons.favorite_border,
                  color: favorita ? Cores.coracao : Cores.verdeEscuro,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 10,
                    child: ImagemReceita(url: receita.image, raio: 24),
                  ),
                  const SizedBox(height: 22),
                  if (receita.mealTypes.isNotEmpty) ...[
                    Text(
                      receita.mealTypes.join(', ').toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: Cores.verde,
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                  Text(receita.name, style: Estilo.titulo),
                  if (meta.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(meta, style: Estilo.corpo),
                  ],
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      for (var i = 0; i < chips.length; i++) ...[
                        if (i > 0) const SizedBox(width: 10),
                        Expanded(child: chips[i]),
                      ],
                    ],
                  ),
                  const SizedBox(height: 28),
                  const Text('Ingredientes', style: Estilo.secao),
                  const SizedBox(height: 12),
                  if (receita.ingredients.isEmpty)
                    Text('Nenhum ingrediente informado.', style: Estilo.corpo)
                  else
                    for (final item in receita.ingredients)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 8, right: 12),
                              child: CircleAvatar(
                                radius: 3,
                                backgroundColor: Cores.verde,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                item,
                                style: Estilo.corpo.copyWith(
                                  fontSize: 16,
                                  color: Cores.verdeEscuro,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  const SizedBox(height: 24),
                  const Text('Modo de preparo', style: Estilo.secao),
                  const SizedBox(height: 14),
                  if (receita.instructions.isEmpty)
                    Text('Nenhum passo informado.', style: Estilo.corpo)
                  else
                    for (var i = 0; i < receita.instructions.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Cores.verde,
                              child: Text(
                                '${i + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  receita.instructions[i],
                                  style: Estilo.corpo.copyWith(
                                    fontSize: 16,
                                    color: Cores.verdeEscuro,
                                    height: 1.45,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dado extends StatelessWidget {
  const _Dado({required this.valor, required this.legenda});

  final String valor;
  final String legenda;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Cores.suave,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            valor,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: Cores.verdeEscuro,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            legenda,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: Cores.texto),
          ),
        ],
      ),
    );
  }
}
