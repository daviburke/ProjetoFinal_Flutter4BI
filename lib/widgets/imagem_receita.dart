import 'package:material_ui/material_ui.dart';

import '../theme.dart';

class ImagemReceita extends StatelessWidget {
  const ImagemReceita({super.key, required this.url, this.raio = 14});

  final String? url;
  final double raio;

  Widget _reserva() {
    return Container(
      color: Cores.bege,
      alignment: Alignment.center,
      child: Icon(
        Icons.restaurant,
        size: 32,
        color: Cores.verde.withValues(alpha: 0.4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final endereco = url;
    return ClipRRect(
      borderRadius: BorderRadius.circular(raio),
      child: endereco == null
          ? _reserva()
          : Image.network(
              endereco,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (_, _, _) => _reserva(),
              loadingBuilder: (_, filho, progresso) =>
                  progresso == null ? filho : _reserva(),
            ),
    );
  }
}
