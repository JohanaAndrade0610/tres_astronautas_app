/*
 * @class App
 * @description Clase encargada de gestionar la aplicación.
 * @autor Angela Andrade
 * @version 1.0 02/09/2025 Documentación y creación de la clase.
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'src/presentation/screens/home_screen.dart';
import 'src/presentation/screens/planets_list_screen.dart';
import 'src/presentation/screens/planet_detail_screen.dart';
import 'src/presentation/screens/not_found_screen.dart';

void main() {
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Configuración del enrutador
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (c, s) => const HomeScreen()),
        GoRoute(path: '/planets', builder: (c, s) => const PlanetsListScreen()),
        GoRoute(
          path: '/planets/:id',
          builder: (c, s) {
            final id = s.pathParameters['id'] ?? '';
            return PlanetDetailScreen(id: Uri.decodeComponent(id));
          },
        ),
      ],
      errorBuilder: (c, s) => const NotFoundScreen(),
    );
    // Configuración de la aplicación
    return MaterialApp.router(
      title: 'Tres Astronautas',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
      routerConfig: router,
    );
  }
}
