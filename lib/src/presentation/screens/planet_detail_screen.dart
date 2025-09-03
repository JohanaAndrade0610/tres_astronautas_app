/*
 * @class PlanetDetailScreen
 * @description Clase encargada de mostrar la pantalla de Información de un planeta.
 * @autor Angela Andrade
 * @version 1.0 02/09/2025 Documentación y creación de la clase.
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/custom_footer.dart';
import '../widgets/generic_appbar.dart';
import '../widgets/_animated_blue_border_button.dart';
import '../../providers/providers.dart';

class PlanetDetailScreen extends ConsumerWidget {
  // ID del planeta
  final String id;
  const PlanetDetailScreen({required this.id, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Repositorio de planetas
    final repo = ref.read(planetRepositoryProvider);
    return FutureBuilder(
      future: repo.getPlanet(id), // Obtener el planeta por ID
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(child: CircularProgressIndicator()), // Indicador de carga
          );
        }
        if (snapshot.hasError) {
          return Stack(
            children: [
              // Fondo de la pantalla
              Positioned.fill(child: Image.asset('assets/images/background_home.png', fit: BoxFit.cover)),
              Scaffold(
                backgroundColor: Colors.transparent,
                // AppBar
                appBar: const GenericAppBar(),
                body: Center(
                  // Mensaje de error en caso de que no se encuentre el planeta
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('El planeta no existe'),
                      AnimatedBlueBorderButton(
                        onPressed: () => context.go('/planets'),
                        child: const Text(
                          'Volver al listado',
                          style: TextStyle(color: Color(0xFF004766), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar: CustomFooter(
                  currentIndex: 1,
                  onTap: (index) {
                    if (index == 0) {
                      context.go('/');
                    } else if (index == 1) {
                      context.go('/planets');
                    } else if (index == 2) {
                      context.go('/favorites');
                    }
                  },
                ),
              ),
            ],
          );
        }
        // Planeta encontrado
        final planet = snapshot.data!;
        // Estado de los favoritos
        final favs = ref.watch(favoritesProvider);
        return Stack(
          children: [
            // Fondo de la pantalla
            Positioned.fill(child: Image.asset('assets/images/background_home.png', fit: BoxFit.cover)),
            Scaffold(
              backgroundColor: Colors.transparent,
              // AppBar
              appBar: const GenericAppBar(showBackArrow: true),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        favs.when(
                          data: (s) => Center(
                            // Botón para agregar o quitar Planetas de la lista de favoritos
                            child: AnimatedBlueBorderButton(
                              onPressed: () => ref.read(favoritesProvider.notifier).toggle(planet.id),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Icono de favorito
                                  Icon(
                                    s.contains(planet.id) ? Icons.favorite : Icons.favorite_border,
                                    color: s.contains(planet.id) ? Colors.red : const Color(0xFF004766),
                                  ),
                                  const SizedBox(width: 8),
                                  // Texto del botón
                                  Text(
                                    s.contains(planet.id) ? 'Quitar de favoritos' : 'Agregar a favoritos',
                                    style: const TextStyle(color: Color(0xFF004766), fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          loading: () => const Center(child: CircularProgressIndicator()), // Indicador de carga
                          error: (e, st) => const SizedBox(),
                        ),
                        SizedBox(height: 24),
                        Card(
                          color: const Color(0xFFE0E2EF).withOpacity(0.7),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 22.0, bottom: 22.0, left: 28.0, right: 28.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Imagen del planeta
                                if (planet.imageUrl != null)
                                  Center(
                                    child: ClipOval(
                                      child: Image.network(
                                        planet.imageUrl!,
                                        width: 180,
                                        height: 180,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 12),
                                // Nombre del planeta
                                Text('${planet.name}', style: Theme.of(context).textTheme.titleLarge),
                                // Descripción del planeta
                                if (planet.description != null) const SizedBox(height: 12),
                                Text(planet.description!, textAlign: TextAlign.justify),
                                const SizedBox(height: 12),
                                // Masa del planeta
                                Text('Masa: ${planet.massKg ?? 'N/A'}'),
                                // Distancia orbital del planeta
                                Text('Distancia orbital: ${planet.orbitalDistanceKm?.toStringAsFixed(0) ?? 'N/A'} km'),
                                // Número de lunas del planeta
                                Text('Lunas: ${planet.moons ?? 'N/A'}'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Footer
              bottomNavigationBar: CustomFooter(
                currentIndex: 1,
                onTap: (index) {
                  if (index == 0) {
                    context.go('/');
                  } else if (index == 1) {
                    context.go('/planets');
                  } else if (index == 2) {
                    context.go('/favorites');
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
