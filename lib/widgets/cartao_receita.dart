import 'package:material_ui/material_ui.dart';

import '../models/recipe.dart';
import '../screens/detalhe_screen.dart';
import '../state/recipe_store.dart';
import '../theme.dart';
import 'imagem_receita.dart';

class CartaoReceita extends StatelessWidget {
  const CartaoReceita({super.key, required this.receita});

  final Recipe receita;

  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    final favorita = store.ehFavorito(receita.id);
    final meta = [receita.tempoCurto, receita.difficulty].whereType<String>();

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: Cores.borda),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => abrirDetalhe(context, receita),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              height: 128,
              child: Row(
                children: [
                  SizedBox(
                    width: 112,
                    child: ImagemReceita(url: receita.image),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          receita.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Cores.verdeEscuro,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        if (meta.isNotEmpty)
                          Text(
                            meta.join('  •  '),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Cores.texto,
                            ),
                          ),
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                receita.nota ?? '',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Cores.verde,
                                ),
                              ),
                            ),
                            InkResponse(
                              onTap: () => store.alternarFavorito(receita),
                              radius: 22,
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  favorita
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 26,
                                  color: favorita
                                      ? Cores.coracao
                                      : Cores.verdeEscuro,
                                  semanticLabel: favorita
                                      ? 'Remover dos favoritos'
                                      : 'Adicionar aos favoritos',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
