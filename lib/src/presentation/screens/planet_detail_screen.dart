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
import '../../domain/entities/planet.dart';

class PlanetDetailScreen extends ConsumerWidget {
  // ID del planeta
  final String id;
  // Planeta ya precargado para evitar re-fetch
  final Planet? initialPlanet;
  const PlanetDetailScreen({required this.id, this.initialPlanet, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Repositorio de planetas
    final repo = ref.read(planetRepositoryProvider);
    // Se valida si se proporciona initialPlanet
    if (initialPlanet != null) {
      final planet = initialPlanet!;
      final favs = ref.watch(favoritesProvider);
      return _buildDetailWithPlanet(context, ref, planet, favs);
    }

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
          // Si hubo algún problema al obtener la información de un planeta se dirige al usuario a la pantalla de no encontrado.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/not-found');
          });
          return const Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(child: SizedBox.shrink()),
          );
        }
        // Planeta encontrado
        final planet = snapshot.data!;
        // Estado de los favoritos
        final favs = ref.watch(favoritesProvider);
        return _buildDetailWithPlanet(context, ref, planet, favs);
      },
    );
  }

  Widget _buildDetailWithPlanet(BuildContext context, WidgetRef ref, Planet planet, AsyncValue<Set<String>> favs) {
    return Stack(
      children: [
        // Imagen del astronauta
        Positioned.fill(
          child: Image.asset('assets/images/general_wallpaper.png', fit: BoxFit.fitHeight, alignment: Alignment.center),
        ),
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
                          onPressed: () async {
                            // Petición para agregar o quitar de favoritos un planeta
                            try {
                              final wasFavorite = s.contains(planet.id);
                              await ref.read(favoritesProvider.notifier).toggle(planet.id);
                              final message = wasFavorite ? 'Eliminado de favoritos' : 'Agregado a favoritos';
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                            } catch (e) {
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(SnackBar(content: Text('Error actualizando favorito: $e')));
                            }
                          },
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
                            // Imagen del planeta correspondiente
                            if (planet.imageUrl != null)
                              Center(
                                child: LayoutBuilder(
                                  builder: (ctx, ct) {
                                    final w = MediaQuery.of(ctx).size.width;
                                    final size = w < 420 ? 140.0 : (w < 800 ? 180.0 : 220.0);
                                    return ClipOval(
                                      child: Image.network(
                                        planet.imageUrl!,
                                        width: size,
                                        height: size,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (c, child, progress) {
                                          if (progress == null) return child;
                                          return Container(width: size, height: size, color: Colors.grey.shade300);
                                        },
                                        errorBuilder: (c, e, st) => Container(
                                          width: size,
                                          height: size,
                                          color: Colors.grey.shade300,
                                          child: Icon(Icons.broken_image, color: Colors.black45, size: size * 0.4),
                                        ),
                                      ),
                                    );
                                  },
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
                            Text('Masa: ${planet.massKg ?? 'Desconocida'}'),
                            // Distancia orbital del planeta
                            Text(
                              'Distancia orbital: ${planet.orbitalDistanceKm?.toStringAsFixed(0) ?? 'Desconocida'} km',
                            ),
                            // Número de lunas del planeta
                            Text('Lunas: ${planet.moons}'),
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
                context.go('/home');
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
}
