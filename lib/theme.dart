import 'package:material_ui/material_ui.dart';

class Cores {
  static const fundo = Color(0xFFF8F5EE);
  static const verde = Color(0xFF235A4A);
  static const verdeEscuro = Color(0xFF1F3D2F);
  static const texto = Color(0xFF5E6B63);
  static const suave = Color(0xFFE8EFE8);
  static const borda = Color(0xFFE3E1D8);
  static const coracao = Color(0xFFB5472A);
  static const bege = Color(0xFFE9E6D8);
  static const esqueleto = Color(0xFFE3E6DE);
}

class Estilo {
  static const titulo = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w800,
    color: Cores.verdeEscuro,
    height: 1.15,
    letterSpacing: -0.4,
  );
  static const secao = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: Cores.verdeEscuro,
  );
  static const corpo = TextStyle(fontSize: 15, color: Cores.texto, height: 1.4);
  static const rotulo = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: Cores.verdeEscuro,
  );
}

ThemeData criarTema() {
  final esquema = ColorScheme.fromSeed(
    seedColor: Cores.verde,
    surface: Cores.fundo,
  ).copyWith(primary: Cores.verde, error: Cores.coracao);

  return ThemeData(
    useMaterial3: true,
    colorScheme: esquema,
    scaffoldBackgroundColor: Cores.fundo,
    dividerTheme: const DividerThemeData(
      color: Cores.borda,
      thickness: 1,
      space: 1,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      indicatorColor: Cores.suave,
      elevation: 0,
      height: 72,
      labelTextStyle: WidgetStateProperty.resolveWith((estados) {
        final ativo = estados.contains(WidgetState.selected);
        return TextStyle(
          fontSize: 13,
          fontWeight: ativo ? FontWeight.w800 : FontWeight.w500,
          color: ativo ? Cores.verdeEscuro : Cores.texto,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((estados) {
        final ativo = estados.contains(WidgetState.selected);
        return IconThemeData(
          size: 24,
          color: ativo ? Cores.verdeEscuro : Cores.texto,
        );
      }),
    ),
  );
}
