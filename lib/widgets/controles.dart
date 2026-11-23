import 'package:material_ui/material_ui.dart';

import '../theme.dart';

class BotaoPrimario extends StatelessWidget {
  const BotaoPrimario({super.key, required this.rotulo, this.aoPressionar});

  final String rotulo;
  final VoidCallback? aoPressionar;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton(
        onPressed: aoPressionar,
        style: FilledButton.styleFrom(
          backgroundColor: Cores.verde,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Cores.verde.withValues(alpha: 0.55),
          disabledForegroundColor: Colors.white70,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        child: Text(rotulo),
      ),
    );
  }
}

class BotaoContorno extends StatelessWidget {
  const BotaoContorno({super.key, required this.rotulo, this.aoPressionar});

  final String rotulo;
  final VoidCallback? aoPressionar;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: aoPressionar,
        style: OutlinedButton.styleFrom(
          foregroundColor: Cores.verde,
          side: const BorderSide(color: Cores.verde, width: 1.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        child: Text(rotulo),
      ),
    );
  }
}

class CampoBusca extends StatelessWidget {
  const CampoBusca({
    super.key,
    this.controlador,
    this.somenteLeitura = false,
    this.aoTocar,
    this.aoEnviar,
    this.aoMudar,
    this.erro,
  });

  final TextEditingController? controlador;
  final bool somenteLeitura;
  final VoidCallback? aoTocar;
  final VoidCallback? aoEnviar;
  final VoidCallback? aoMudar;
  final String? erro;

  OutlineInputBorder _borda(Color cor, [double largura = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: cor, width: largura),
      );

  @override
  Widget build(BuildContext context) {
    final campo = TextField(
      controller: controlador,
      readOnly: somenteLeitura,
      textInputAction: TextInputAction.search,
      onSubmitted: aoEnviar == null ? null : (_) => aoEnviar!(),
      onChanged: aoMudar == null ? null : (_) => aoMudar!(),
      style: const TextStyle(fontSize: 16, color: Cores.verdeEscuro),
      decoration: InputDecoration(
        hintText: 'Buscar pelo nome',
        hintStyle: const TextStyle(color: Cores.texto),
        prefixIcon: const Icon(Icons.search, color: Cores.texto),
        errorText: erro,
        errorStyle: const TextStyle(color: Cores.coracao, fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        enabledBorder: _borda(Cores.borda),
        focusedBorder: _borda(Cores.verde, 1.6),
        errorBorder: _borda(Cores.coracao),
        focusedErrorBorder: _borda(Cores.coracao, 1.6),
      ),
    );

    if (!somenteLeitura) return campo;
    return GestureDetector(
      onTap: aoTocar,
      child: AbsorbPointer(child: campo),
    );
  }
}
