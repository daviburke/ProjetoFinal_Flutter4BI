import 'package:material_ui/material_ui.dart';

import 'screens/favoritos_screen.dart';
import 'screens/home_screen.dart';
import 'theme.dart';

class SaboreApp extends StatelessWidget {
  const SaboreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saborê',
      debugShowCheckedModeBanner: false,
      theme: criarTema(),
      home: const Casca(),
    );
  }
}

class Casca extends StatefulWidget {
  const Casca({super.key});

  @override
  State<Casca> createState() => _CascaState();
}

class _CascaState extends State<Casca> {
  final _navegador = GlobalKey<NavigatorState>();
  int _aba = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _aba,
        children: [
          NavigatorPopHandler(
            enabled: _aba == 0,
            onPopWithResult: (_) => _navegador.currentState?.maybePop(),
            child: Navigator(
              key: _navegador,
              onGenerateRoute: (_) =>
                  MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
            ),
          ),
          FavoritosScreen(aoExplorar: () => setState(() => _aba = 0)),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _aba,
        onDestinationSelected: (i) => setState(() => _aba = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.search), label: 'Explorar'),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite, color: Cores.coracao),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }
}
