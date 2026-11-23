import 'package:material_ui/material_ui.dart';

import '../state/recipe_store.dart';
import '../theme.dart';
import '../widgets/cabecalho.dart';
import '../widgets/cartao_receita.dart';
import '../widgets/estados.dart';

class FavoritosScreen extends StatelessWidget {
  const FavoritosScreen({super.key, required this.aoExplorar});

  final VoidCallback aoExplorar;

  @override
  Widget build(BuildContext context) {
    final favoritos = StoreScope.of(context).favoritos;

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          const CabecalhoMarca(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              children: favoritos.isEmpty
                  ? [
                      EstadoVazio(
                        icone: const Icon(
                          Icons.favorite_border,
                          size: 44,
                          color: Cores.verdeEscuro,
                        ),
                        titulo: 'Nenhum favorito',
                        mensagem: 'Marque uma receita como favorita para encontrá-la aqui.',
                        rotuloAcao: 'Explorar receitas',
                        aoAgir: aoExplorar,
                      ),
                    ]
                  : [
                      const Text('Favoritos', style: Estilo.titulo),
                      const SizedBox(height: 8),
                      Text(
                        'Receitas salvas nesta sessão.',
                        style: Estilo.corpo,
                      ),
                      const SizedBox(height: 22),
                      for (final r in favoritos) CartaoReceita(receita: r),
                      const SizedBox(height: 10),
                      Text(
                        'Toque no coração para remover.',
                        style: Estilo.corpo.copyWith(fontSize: 14),
                      ),
                    ],
            ),
          ),
        ],
      ),
    );
  }
}
