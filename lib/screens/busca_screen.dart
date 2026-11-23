import 'package:material_ui/material_ui.dart';

import '../state/recipe_store.dart';
import '../theme.dart';
import '../widgets/cabecalho.dart';
import '../widgets/cartao_receita.dart';
import '../widgets/controles.dart';
import '../widgets/estados.dart';

class BuscaScreen extends StatefulWidget {
  const BuscaScreen({super.key});

  @override
  State<BuscaScreen> createState() => _BuscaScreenState();
}

class _BuscaScreenState extends State<BuscaScreen> {
  final _controlador = TextEditingController();
  String? _erroCampo;

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  void _pesquisar() {
    final termo = _controlador.text.trim();
    if (termo.isEmpty) {
      setState(() => _erroCampo = 'Digite um nome para pesquisar.');
      return;
    }
    FocusScope.of(context).unfocus();
    _controlador.text = termo;
    setState(() => _erroCampo = null);
    StoreScope.ler(context).pesquisar(termo);
  }

  void _limpar() {
    _controlador.clear();
    setState(() => _erroCampo = null);
    StoreScope.ler(context).limparBusca();
  }

  Widget _formulario(RecipeStore store) {
    final buscando = store.estadoBusca == EstadoBusca.carregando;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Nome da receita', style: Estilo.rotulo),
        const SizedBox(height: 10),
        CampoBusca(
          controlador: _controlador,
          erro: _erroCampo,
          aoEnviar: buscando ? null : _pesquisar,
          aoMudar: () {
            if (_erroCampo != null) setState(() => _erroCampo = null);
          },
        ),
        const SizedBox(height: 14),
        BotaoPrimario(
          rotulo: buscando ? 'Buscando...' : 'Pesquisar',
          aoPressionar: buscando ? null : _pesquisar,
        ),
      ],
    );
  }

  List<Widget> _conteudo(RecipeStore store) {
    switch (store.estadoBusca) {
      case EstadoBusca.parada:
        return [
          const Text('Qual receita você procura?', style: Estilo.titulo),
          const SizedBox(height: 24),
          _formulario(store),
          const SizedBox(height: 28),
          Text(
            'Você pode buscar por parte do nome da receita.',
            style: Estilo.corpo.copyWith(fontSize: 16),
          ),
        ];
      case EstadoBusca.carregando:
        return [
          _formulario(store),
          const SizedBox(height: 28),
          const EsqueletoLista(itens: 1),
        ];
      case EstadoBusca.resultados:
        return [
          _formulario(store),
          const SizedBox(height: 28),
          Text('Resultados para “${store.consulta}”', style: Estilo.secao),
          const SizedBox(height: 6),
          Text(
            'Toque na receita para ver o preparo.',
            style: Estilo.corpo.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 18),
          for (final r in store.resultados) CartaoReceita(receita: r),
          const SizedBox(height: 10),
          BotaoContorno(rotulo: 'Limpar pesquisa', aoPressionar: _limpar),
        ];
      case EstadoBusca.vazio:
        return [
          CampoBusca(
            controlador: _controlador,
            somenteLeitura: true,
            aoTocar: store.editarBusca,
          ),
          EstadoVazio(
            icone: const Icon(Icons.search, size: 36, color: Cores.texto),
            titulo: 'Nenhum resultado',
            mensagem:
                'Não encontramos receitas para esse nome. Tente outro termo.',
            rotuloAcao: 'Alterar pesquisa',
            aoAgir: store.editarBusca,
            rotuloSecundario: 'Ver todas as receitas',
            aoAgirSecundario: () => Navigator.of(context).maybePop(),
          ),
        ];
      case EstadoBusca.erro:
        return [
          CampoBusca(
            controlador: _controlador,
            somenteLeitura: true,
            aoTocar: store.editarBusca,
          ),
          EstadoVazio(
            icone: const IconeAlerta(),
            titulo: 'Não foi possível pesquisar.',
            mensagem: store.erroBusca?.mensagem ?? '',
            rotuloAcao: 'Tentar novamente',
            aoAgir: () => store.pesquisar(store.consulta),
            rotuloSecundario: 'Alterar pesquisa',
            aoAgirSecundario: store.editarBusca,
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);

    return PopScope(
      onPopInvokedWithResult: (voltou, _) {
        if (voltou) store.limparBusca();
      },
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              CabecalhoVoltar(
                titulo: 'Pesquisar receitas',
                aoVoltar: () => Navigator.of(context).maybePop(),
              ),
              Expanded(
                child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                  children: _conteudo(store),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
