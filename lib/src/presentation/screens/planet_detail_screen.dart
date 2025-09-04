/*
 * @class PlanetDetailScreen
 * @description Clase encargada de mostrar la pantalla de Información de un planeta.
 * @autor Angela Andrade
 * @version 1.0 02/09/2025 Documentación y creación de la clase.
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import '../widgets/custom_footer.dart';
import '../widgets/generic_appbar.dart';
import '../../providers/providers.dart';
import '../../domain/entities/planet.dart';
import '../utils/screen_helper.dart';

/*
 * @method _assetExists
 * @description Método encargado de verificar si la imagen del planeta existe en el bundle.
 */
Future<bool> _assetExists(String assetPath) async {
  try {
    await rootBundle.load(assetPath);
    return true;
  } catch (_) {
    return false;
  }
}

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
      final favs = ref.read(favoritesProvider);
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
          child: Image.asset(
            'assets/images/general_wallpaper2.png',
            fit: BoxFit.fitHeight,
            alignment: Alignment.center,
            gaplessPlayback: true,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          // AppBar
          appBar: const GenericAppBar(showBackArrow: true),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Card con la información del planeta
                    Card(
                      color: const Color(0xFFE0E2EF).withOpacity(0.7),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 22.0, bottom: 22.0, left: 28.0, right: 28.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: LayoutBuilder(
                                    builder: (ctx, ct) {
                                      final size = ScreenHelper.getResponsiveSize(
                                        ctx,
                                        mobile: 0.4,
                                        tablet: 0.225,
                                        desktop: 0.1,
                                      );
                                      final assetPath = 'assets/images/planets/${planet.name.toLowerCase()}.png';
                                      return ClipOval(
                                        child: FutureBuilder<bool>(
                                          future: _assetExists(assetPath),
                                          builder: (c, snap) {
                                            if (snap.connectionState == ConnectionState.done && snap.data == true) {
                                              return Image.asset(
                                                assetPath,
                                                width: size,
                                                height: size,
                                                fit: BoxFit.cover,
                                                gaplessPlayback: true,
                                                errorBuilder: (c, e, st) => Container(
                                                  width: size,
                                                  height: size,
                                                  color: Colors.grey.shade300,
                                                  child: Icon(
                                                    Icons.broken_image,
                                                    color: Colors.black45,
                                                    size: size * 0.4,
                                                  ),
                                                ),
                                              );
                                            }
                                            return Container(
                                              width: size,
                                              height: size,
                                              color: Colors.grey.shade300,
                                              child: Icon(Icons.broken_image, color: Colors.black45, size: size * 0.4),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Nombre del planeta en negrita
                                Text(
                                  '${planet.name}',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                if (planet.description != null) const SizedBox(height: 12),
                                // Descripción del planeta
                                Text(planet.description!, textAlign: TextAlign.justify),
                                const SizedBox(height: 12),
                                // Masa del planeta en negrita
                                RichText(
                                  text: TextSpan(
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    children: [
                                      const TextSpan(text: 'Masa: ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                      TextSpan(text: '${planet.massKg ?? 'Desconocida'}', style: const TextStyle(color: Colors.black)),
                                    ],
                                  ),
                                ),
                                // Distancia orbital en negrita
                                RichText(
                                  text: TextSpan(
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    children: [
                                      const TextSpan(text: 'Distancia orbital: ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                      TextSpan(text: '${planet.orbitalDistanceKm?.toStringAsFixed(0) ?? 'Desconocida'} km', style: const TextStyle(color: Colors.black)),
                                    ],
                                  ),
                                ),
                                // Lunas en negrita
                                RichText(
                                  text: TextSpan(
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    children: [
                                      const TextSpan(text: 'Lunas: ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                      TextSpan(text: '${planet.moons}', style: const TextStyle(color: Colors.black)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Botón de favoritos aislado en su propio ConsumerWidget para que solo él se reconstruya
                          Positioned(bottom: 16, right: 16, child: _FavoriteButton(planetId: planet.id)),
                        ],
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

// Widget de favoritos
class _FavoriteButton extends ConsumerWidget {
  final String planetId;
  const _FavoriteButton({required this.planetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favs = ref.watch(favoritesProvider);
    // Obtener deviceType localmente
    final deviceType = ScreenHelper.getDeviceType(context);

    return favs.when(
      data: (s) {
        final isFavorite = s.contains(planetId);
        return ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            padding: deviceType == DeviceType.mobile
                ? const EdgeInsets.all(12)
                : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : const Color(0xFF004766),
          ),
          label: deviceType == DeviceType.mobile
              ? const SizedBox.shrink()
              : Text(
                  isFavorite ? 'Quitar de favoritos' : 'Agregar a favoritos',
                  style: const TextStyle(color: Color(0xFF004766), fontWeight: FontWeight.bold),
                ),
          onPressed: () async {
            try {
              await ref.read(favoritesProvider.notifier).toggle(planetId);
              final message = isFavorite ? 'Eliminado de favoritos' : 'Agregado a favoritos';
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error actualizando favorito: $e')));
            }
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => const SizedBox(),
    );
  }
}
