import 'package:material_ui/material_ui.dart';

import '../state/recipe_store.dart';
import '../theme.dart';
import '../widgets/cabecalho.dart';
import '../widgets/cartao_receita.dart';
import '../widgets/controles.dart';
import '../widgets/estados.dart';
import 'busca_screen.dart';

void abrirBusca(BuildContext context) {
  if (ModalRoute.of(context)?.isCurrent == false) return;
  Navigator.of(context)
      .push(MaterialPageRoute<void>(builder: (_) => const BuscaScreen()));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          const CabecalhoMarca(),
          Expanded(child: _corpo(context, store)),
        ],
      ),
    );
  }

  Widget _corpo(BuildContext context, RecipeStore store) {
    const margem = EdgeInsets.fromLTRB(20, 24, 20, 24);

    switch (store.catalogo) {
      case Carga.inicial:
      case Carga.carregando:
        return ListView(
          padding: margem,
          children: const [
            Text('Explorar receitas', style: Estilo.titulo),
            SizedBox(height: 24),
            EsqueletoLista(),
          ],
        );
      case Carga.erro:
        return ListView(
          padding: margem,
          children: [
            EstadoVazio(
              icone: const IconeAlerta(),
              titulo: 'Não foi possível carregar as receitas.',
              mensagem: store.erroCatalogo?.mensagem ?? '',
              rotuloAcao: 'Tentar novamente',
              aoAgir: store.carregarReceitas,
            ),
          ],
        );
      case Carga.pronto:
        return ListView(
          padding: margem,
          children: [
            const Text('Receitas', style: Estilo.titulo),
            const SizedBox(height: 8),
            Text('Pesquise uma receita pelo nome.', style: Estilo.corpo),
            const SizedBox(height: 22),
            CampoBusca(
              somenteLeitura: true,
              aoTocar: () => abrirBusca(context),
            ),
            const SizedBox(height: 14),
            BotaoPrimario(
              rotulo: 'Buscar receitas',
              aoPressionar: () => abrirBusca(context),
            ),
            const SizedBox(height: 32),
            const Text('Receitas disponíveis', style: Estilo.secao),
            const SizedBox(height: 6),
            Text(
              'Selecione uma receita para ver o preparo.',
              style: Estilo.corpo.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 18),
            if (store.receitas.isEmpty)
              Text(
                'Nenhuma receita disponível no momento.',
                style: Estilo.corpo,
              ),
            for (final r in store.receitas) CartaoReceita(receita: r),
          ],
        );
    }
  }
}
