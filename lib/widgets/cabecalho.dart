import 'package:material_ui/material_ui.dart';

import '../theme.dart';

class CabecalhoMarca extends StatelessWidget {
  const CabecalhoMarca({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Text('Saborê', style: Estilo.titulo),
        ),
        Divider(),
      ],
    );
  }
}

class CabecalhoVoltar extends StatelessWidget {
  const CabecalhoVoltar({
    super.key,
    required this.titulo,
    required this.aoVoltar,
    this.acao,
  });

  final String titulo;
  final VoidCallback aoVoltar;
  final Widget? acao;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 12, 12),
          child: Row(
            children: [
              IconButton(
                onPressed: aoVoltar,
                tooltip: 'Voltar',
                icon: const Icon(Icons.arrow_back, color: Cores.verdeEscuro),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Cores.verdeEscuro,
                  ),
                ),
              ),
              ?acao,
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
