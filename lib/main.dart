/*
 * @class App
 * @description Clase encargada de gestionar la aplicación.
 * @autor Angela Andrade
 * @version 1.0 02/09/2025 Documentación y creación de la clase.
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'src/presentation/screens/home_screen.dart';
import 'src/presentation/screens/planets_list_screen.dart';
import 'src/presentation/screens/planet_detail_screen.dart';
import 'src/domain/entities/planet.dart';
import 'src/presentation/screens/not_found_screen.dart';
import 'src/presentation/screens/favorites_screen.dart';

void main() {
  setUrlStrategy(PathUrlStrategy());
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Configuración del enrutador
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(path: '/home', builder: (c, s) => const HomeScreen()), // Inicio
        GoRoute(path: '/planets', builder: (c, s) => const PlanetsListScreen()), // Lista de Planetas
        GoRoute(path: '/favorites', builder: (c, s) => const FavoritesScreen()), // Planetas favoritos
        GoRoute(path: '/not-found', builder: (c, s) => const NotFoundScreen()), // Planeta no encontrado
        GoRoute(
          path: '/planets/:planet',
          builder: (c, s) {
            final planet = s.pathParameters['planet'];
            final extra = s.extra;
            final Planet? initialPlanet = extra is Planet ? extra : null;
            return PlanetDetailScreen(id: Uri.decodeComponent(planet!), initialPlanet: initialPlanet);
          },
        ), // Detalles de un planeta en específico
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
