import 'package:material_ui/material_ui.dart';

import '../theme.dart';
import 'controles.dart';

class EstadoVazio extends StatelessWidget {
  const EstadoVazio({
    super.key,
    required this.icone,
    required this.titulo,
    required this.mensagem,
    required this.rotuloAcao,
    required this.aoAgir,
    this.rotuloSecundario,
    this.aoAgirSecundario,
  });

  final Widget icone;
  final String titulo;
  final String mensagem;
  final String rotuloAcao;
  final VoidCallback aoAgir;
  final String? rotuloSecundario;
  final VoidCallback? aoAgirSecundario;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        Center(
          child: Container(
            width: 132,
            height: 132,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Cores.suave,
              shape: BoxShape.circle,
            ),
            child: icone,
          ),
        ),
        const SizedBox(height: 32),
        Text(titulo, style: Estilo.titulo),
        const SizedBox(height: 12),
        Text(mensagem, style: Estilo.corpo.copyWith(fontSize: 16)),
        const SizedBox(height: 32),
        BotaoPrimario(rotulo: rotuloAcao, aoPressionar: aoAgir),
        if (rotuloSecundario != null) ...[
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: aoAgirSecundario,
              style: TextButton.styleFrom(foregroundColor: Cores.verde),
              child: Text(
                rotuloSecundario!,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class IconeAlerta extends StatelessWidget {
  const IconeAlerta({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      '!',
      style: TextStyle(
        fontSize: 56,
        fontWeight: FontWeight.w900,
        color: Cores.verde,
      ),
    );
  }
}

class EsqueletoLista extends StatefulWidget {
  const EsqueletoLista({super.key, this.itens = 2});

  final int itens;

  @override
  State<EsqueletoLista> createState() => _EsqueletoListaState();
}

class _EsqueletoListaState extends State<EsqueletoLista>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulso = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulso.dispose();
    super.dispose();
  }

  Widget _bloco({double? largura, required double altura, double raio = 8}) {
    return Container(
      width: largura,
      height: altura,
      decoration: BoxDecoration(
        color: Cores.esqueleto,
        borderRadius: BorderRadius.circular(raio),
      ),
    );
  }

  Widget _cartao() {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          _bloco(largura: 112, altura: 104, raio: 14),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _bloco(altura: 14),
                const SizedBox(height: 12),
                _bloco(altura: 14, largura: 120),
                const SizedBox(height: 28),
                _bloco(altura: 12, largura: 70),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Carregando receitas',
      child: FadeTransition(
        opacity: Tween(begin: 0.45, end: 1.0).animate(_pulso),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _bloco(altura: 56, raio: 18),
            const SizedBox(height: 22),
            for (var i = 0; i < widget.itens; i++) _cartao(),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Carregando receitas...',
                style: TextStyle(fontSize: 14, color: Cores.texto),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
